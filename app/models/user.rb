class User < ActiveRecord::Base

  STRING_SEPARATOR = ', '

  attr_accessible :username, :first_name, :last_name, :title, :email, :department, :photo_url, :password, :remember_me, :department_ids
  alias_attribute :netid, :username
  validates :username, :presence => true, :uniqueness => true
  has_many :department_users
  has_many :departments, :through => :department_users

  default_scope :order => 'first_name, last_name'

  scope :affiliation, lambda { |affiliation|
    User.conditions_for_separated_fields(:affiliations=>affiliation)
  }

  scope :entitlement, lambda { |entitlement|
    User.conditions_for_separated_fields(:entitlements=>User.role_to_entitlement(entitlement))
  }

  scope :role, lambda { |role|
    User.conditions_for_separated_fields(
      :affiliations=>role,
      :entitlements=>User.role_to_entitlement(role)
    )
  }

  def name
    "#{self.first_name} #{self.last_name}".strip
  end

  def recent_sign_in_at
    self.current_sign_in_at || self.last_sign_in_at
  end

  def affiliations
    read_attribute(:affiliations).split(STRING_SEPARATOR)
  end

  def affiliations=(affiliations)
    raise TypeError.new('argument is not an array') unless affiliations.is_a?(Array)
    write_attribute(:affiliations, affiliations.join(STRING_SEPARATOR))
  end

  def entitlements
    read_attribute(:entitlements).split(STRING_SEPARATOR)
  end

  def entitlements=(entitlements)
    raise TypeError.new('entitlementes is not an array') unless entitlements.is_a?(Array)
    write_attribute(:entitlements, entitlements.join(STRING_SEPARATOR))
  end

  def roles(include_unallowed=true)

    roles = self.entitlements.map{ |e| User.entitlement_to_role(e) }.compact
    if Settings.security.roles.include_affiliations
      roles += self.affiliations
    end

    roles.uniq!

    if include_unallowed
      return roles
    else
      return roles & allowed_roles
    end

  end

  def role_symbols(include_undefined=true)
    roles(include_undefined).map(&:to_sym)
  end

  def has_role?(roles)
    roles = Array(roles).map(&:to_sym)
    not (roles & self.role_symbols).empty?
  end

  def is_admin?
    self.has_role?(:admin) || self.is_developer?
  end

  def is_developer?
    self.has_role?(:developer)
  end

  def can_login?
    self.has_role? allowed_roles
  end

  def cas_extra_attributes=(extra_attributes)
    extra_attributes.each do |name, value|
      case name.to_sym
      when :cn
        self.username = value.first
      when :eduPersonEntitlement
        self.entitlements = value
      when :url
        self.photo_url = value.first
      when :department
        self.department = value.first
      when :title
        self.title = value.first
      when :eduPersonAffiliation
        self.affiliations = value
      when :mail
        self.email = value.first
      when :eduPersonNickname
        self.first_name = value.first
      when :sn
        self.last_name = value.first
      end
    end

    {
      username: username,
      entitlements: entitlements,
      photo_url: photo_url,
      department: department,
      title: title,
      affiliations: affiliations,
      first_name: first_name,
      last_name: last_name
    }
  end

  def self.entitlement_to_role(entitlement)

    group = Settings.security.roles.base_entitlement

    if entitlement[0, group.length] == group
      return entitlement[group.length..entitlement.length]
    else
      return nil
    end

  end

  def self.role_to_entitlement(role)

    "#{Settings.security.roles.base_entitlement}#{role}"

  end

  def self.allowed_roles
    Authorization::Engine.instance.roles.map(&:to_s)
  end

  private

  def self.conditions_for_separated_fields(conditions)

    fields = []; searches = []

    conditions.each do |field, search|
      fields << PortAQuery.concat(STRING_SEPARATOR, field.to_sym, STRING_SEPARATOR)
      searches << search.to_s.wrap(STRING_SEPARATOR).wrap('%')
    end

    { :conditions=>[fields.map{|f| "#{f} LIKE ?" }.join(' OR '), *searches] }

  end

end
