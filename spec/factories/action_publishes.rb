FactoryBot.define do
  factory :action_publish, class: 'Action::Publish' do
    user nil
    document nil
    change_note "MyText"
    with_review false
    all_document_attributes {}
  end
end
