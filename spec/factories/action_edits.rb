FactoryBot.define do
  factory :action_edit, class: 'Action::Edit' do
    user nil
    document nil
    changeset ""
  end
end
