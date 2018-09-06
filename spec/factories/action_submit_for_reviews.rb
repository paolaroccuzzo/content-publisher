FactoryBot.define do
  factory :action_submit_for_review, class: 'Action::SubmitForReview' do
    user nil
    document nil
  end
end
