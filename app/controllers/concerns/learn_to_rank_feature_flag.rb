module LearnToRankFeatureFlag
  def ranker_ab_test_params
    ranker_enabled ? { relevance: "B" } : {}
  end

  def ranker_enabled
    true
  end
end
