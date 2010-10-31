class User < ActiveRecord::Base

  STRING_SEPARATOR = ', '

  devise :netid_authenticatable, :rememberable, :trackable, :timeoutable

  attr_accessible :username, :first_name, :last_name, :title, :email, :department, :photo_url, :password, :remember_me
  alias_attribute :netid, :username
  has_many :slides
  validates_presence_of :username
  validates_uniqueness_of :username
  def validate
    self.errors.add(:username, "cannot be found") unless BiolaWebServices.dirsvc.user_exists?(:netid=>self.netid)
  end

  before_save :update_from_directory

  default_scope :order => 'first_name, last_name'
  
  named_scope :affiliation, lambda { |affiliation|
    User.conditions_for_separated_fields(:affiliations=>affiliation)
  }
  
  named_scope :entitlement, lambda { |entitlement|
    User.conditions_for_separated_fields(:entitlements=>User.role_to_entitlement(entitlement))
  }
  
  named_scope :role, lambda { |role|
    User.conditions_for_separated_fields(
      :affiliations=>role,
      :entitlements=>User.role_to_entitlement(role)
    )
  }
  
  def name
    "#{self.first_name} #{self.last_name}".strip
  end

  def active_slides
    self.slides.reject { |s| !s.active? }
  end
  
  def expired_slides
    self.slides.reject { |s| s.expired? }
  end

  def active_slides_time
    Slide.total_time self.active_slides
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
  
  def roles(include_undefined=true)
  
    defined_roles = Authorization::Engine.instance.roles.map(&:to_s)
  
    roles = self.entitlements.map{ |e| User.entitlement_to_role(e) }.compact
    if AppConfig.security.roles.include_affiliations
      roles += self.affiliations
    end
    
    roles.uniq!
    
    if include_undefined
      return roles
    else
      return roles & defined_roles
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
    self.has_role?(:admin)
  end

  def groups
    BiolaWebServices.dirsvc.get_group_membership(:netid=>self.username)
  end

  def group_names
    self.groups.map{|g| g['cn']}
  end

  def in_group?(group)
    group = group['cn'] if group.is_a?(Hash)
    BiolaWebServices.dirsvc.is_user_in_group?(:netid=>self.username, :group=>group)
  end

  # Called by Devise NETID Authenticable plugin
  def can_login?
    self.update_from_directory(true)
    self.has_role?(AppConfig.security.login.allowed_roles)
  end

  # Called by Devise NETID Authenticable plugin
  def can_impersonate?(user=nil)
  
    config = AppConfig.security.login.impersonation
    
    return true unless (self.roles & config.allowed_roles).empty?
    return true unless (self.group_names & config.allowed_groups).empty?
    
    false
    
  end

  def self.entitlement_to_role(entitlement)
  
    group = AppConfig.security.roles.base_entitlement
    
    if entitlement[0, group.length] == group
      return entitlement[group.length..entitlement.length]
    else
      return nil
    end
    
  end

  def self.role_to_entitlement(role)
  
    "#{AppConfig.security.roles.base_entitlement}#{role}"
    
  end

  def update_from_directory(force=false)
  
    if AppConfig.security.users.auto_update || force
  
      dir_user = BiolaWebServices.dirsvc.get_user(:id=>self.username)
    
      unless dir_user.nil? || dir_user['error'] || dir_user['netid'] != self.netid
    
        self.username = dir_user['netid']
        self.first_name = dir_user['preferredname']
        self.last_name = dir_user['lastname']
        self.title = dir_user['title']
        self.email = dir_user['email'].try(:first) || ''
        self.department = dir_user['department']
        self.affiliations = dir_user['affiliations']
        self.entitlements = dir_user['entitlements']
      
        # Validate photo_url 
        if HTTParty.head(dir_user['photourl']).response.is_a?(Net::HTTPSuccess)
          self.photo_url = dir_user['photourl']
        else
          self.photo_url = ''
        end
        
      end
  
    end
  
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
