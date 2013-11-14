class User < ActiveRecord::Base
  include Humanity::Base

  alias_attribute :netid, :username
  validates :username, presence: true, uniqueness: true
  has_many :department_users
  has_many :departments, through: :department_users
  has_many :signs, through: :departments
  has_many :slides, through: :departments

  scope :custom_search, -> query {
    where('username LIKE ? OR first_name LIKE ? OR last_name LIKE ?', *(["%#{query}%"]*3)) unless query.blank?
  }

  # Sometimes admins and developers still need access to all departments
  def all_departments
    if admin? || developer?
      Department.all
    else
      self.departments
    end
  end

  def affiliations
    @affiliations ||= roles.where(Humanity::Assignment.by_source(:affilation))
  end

  def entitlements
    @entitlements ||= roles.where(Humanity::Assignment.by_source(:entitlement))
  end

  def authorized_roles
    roles & Authorization::Engine.instance.roles.map(&:to_s)
  end

  def update_from_cas!(extra_attributes)
    cas_attr = HashWithIndifferentAccess.new(extra_attributes)

    entitlements = User.convert_urns(cas_attr[:eduPersonEntitlement], Settings.urn_namespaces)

    self.username ||= cas_attr[:cn].try(:first)
    self.photo_url ||= cas_attr[:url].try(:first)
    self.department ||= cas_attr[:department].try(:first)
    self.title ||= cas_attr[:title].try(:first)
    self.email ||= cas_attr[:mail].try(:first)
    self.first_name ||= cas_attr[:eduPersonNickname].try(:first)
    self.last_name ||= cas_attr[:sn].try(:first)

    self.save \
    && self.update_roles!(cas_attr[:eduPersonAffiliation], :affiliation) \
    && self.update_roles!(entitlements, :entitlement)
  end

  # Find URNs that match the namespaces and remove the namespace
  # See http://en.wikipedia.org/wiki/Uniform_Resource_Name
  def self.convert_urns(urns, nids)
    return [] if urns.blank?

    clean_urns = urns.map { |e| e.gsub(/^urn:/i, '') }
    clean_nids = nids.map { |n| n.gsub(/^urn:/i, '') }

    clean_urns.map { |urn|
      clean_nids.map { |nid|
        urn[0...nid.length] == nid ? urn[nid.length..urn.length] : nil
      }
    }.flatten.compact
  end
end