def redirect_path_for(resource)
  controller = "#{resource.class.model_name.plural}_controller".classify.constantize.new

  obj = controller.respond_to?(:show) ? resource : resource.class

  nester = nested_in_object
  nester.nil?? obj : [nester, obj]
end

def nested_in_object
  nested_in rescue nil
end

def nested_in_param
  nester = nested_in_object

  return {} if nester.nil?

  {"#{nester.class.model_name.param_key}_id" => nester.to_param}
end

# Usage:
# it_behaves_like 'an index action'
shared_examples_for 'an index action' do
  describe '#index' do
    before { get :index, nested_in_param }

    it { should respond_with :success }
    it { should render_template :index }
  end
end

# Usage:
# describe :show do
#   let(:params) { {id: user.to_param} }
#   it_behaves_like 'a show action'
# end
shared_examples_for 'a show action' do
  describe '#show' do
    before { get :show, params.merge(nested_in_param) }

    it { should respond_with :success }
    it { should render_template :show }
  end
end

# Usage:
# it_behaves_like 'a new action'
shared_examples_for 'a new action' do
  describe '#new' do
    before { get :new, nested_in_param }

    it { should respond_with :success }
    it { should render_template :new }
  end
end

# Usage:
# describe :edit do
#   let(:params) { {id: user.to_param} }
#   it_behaves_like 'an edit action'
# end
shared_examples_for 'an edit action' do
  describe '#edit' do
    before { get :edit, params.merge(nested_in_param) }

    it { should respond_with :success }
    it { should render_template :edit }
  end
end

# Usage:
# describe :create do
#   let(:valid_params) { {username: 'johndoe'} }
#   let(:invalid_params) { {username: ''} }
#   it_behaves_like 'a create action', for: :user
# end
shared_examples_for 'a create action' do |options|
  let(:resource_name) { options[:for] }
  let(:klass) { resource_name.to_s.classify.constantize }

  describe '#create' do
    let(:request) { post :create, nested_in_param.merge(resource_name => params) }

    context 'invalid attributes' do
      let(:params) { invalid_params }

      describe 'request' do
        it { expect { request }.to_not change(klass, :count) }
      end

      describe 'response' do
        before { request }
        it { should respond_with :success }
        it { should render_template :new }
      end
    end

    context 'valid attributes' do
      let(:params) { valid_params }

      describe 'request' do
        it { expect { request }.to change(klass, :count).by 1 }
      end

      describe 'response' do
        before { request }
        it { should redirect_to redirect_path_for(assigns(resource_name)) }
      end
    end
  end
end

# Usage:
# describe :update do
#   let(:resource) { User.create(username: 'johndoe') }
#   let(:valid_params) { {username: 'johnnydoe'} }
#   let(:invalid_params) { {username: ''} }
#   it_behaves_like 'an update action'
# end
shared_examples_for 'an update action' do |options|
  let(:resource_name) { resource.class.model_name.param_key }
  let(:klass) { resource_name.to_s.classify.constantize }

  describe :update do
    let(:request) { put :update, nested_in_param.merge(id: resource.to_param, resource_name => params) }
    context 'invalid attributes' do
      let(:params) { invalid_params }

      describe 'request' do
        it { expect { request }.to_not change { klass.find(resource.id).updated_at } }
      end

      describe 'response' do
        before { request }
        it { should respond_with :success }
        it { should render_template :edit }
      end
    end

    context 'valid attributes' do
      let(:params) { valid_params }

      describe 'request' do
        it { expect { request }.to change { klass.find(resource.id).updated_at } }
      end

      describe 'response' do
        before { request }
        it { should redirect_to redirect_path_for(resource) }
      end
    end
  end
end

# Usage:
# describe :destroy do
#   let(:params) { {id: user.to_param} }
#   it_behaves_like 'a destroy action', for: :user
# end
shared_examples_for 'a destroy action' do |options|
  let(:resource_name) { options[:for] }
  let(:klass) { resource_name.to_s.classify.constantize }

  describe '#destroy' do
    let(:request) { delete :destroy, nested_in_param.merge(params) }

    before { params } # make sure we work around lazy loading and build any necessary models

    it 'should delete the resource and redirect to the index' do
      expect { request }.to change(klass, :count).by -1
      request.should redirect_to resource_name.to_s.classify.constantize
    end
  end
end