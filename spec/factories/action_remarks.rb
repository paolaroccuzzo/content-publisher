FactoryBot.define do
  factory :action_remark, class: 'Action::Remark' do
    user nil
    document nil
    message "MyText"
  end
end
