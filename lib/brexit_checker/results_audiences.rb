class BrexitChecker::ResultsAudiences
  class << self
    def populate_business_groups(audience_actions, selected_criteria)
      return [] if audience_actions.blank? || selected_criteria.blank?

      {
        actions: audience_actions,
        criteria: filter_criteria_by_actions(audience_actions, selected_criteria),
      }
    end

    def populate_citizen_groups(audience_actions, selected_criteria)
      return [] if audience_actions.blank? || selected_criteria.blank?

      all_possible_groups = BrexitChecker::Groups.load_all
      grouped_actions = all_possible_groups.each_with_index.map do |group, group_index|
        actions_in_group = filter_actions_by_group(audience_actions, group.key)
        if actions_in_group.empty?
          nil
        else
          {
            group: group,
            group_index: group_index + 1,
            actions: actions_in_group,
            criteria: filter_criteria_by_actions(actions_in_group, selected_criteria),
          }
        end
      end
      grouped_actions.compact
    end

  private

    def filter_actions_by_group(actions, group_key)
      actions.select { |action| action.grouping_criteria.include?(group_key) }
    end

    def extract_groupings(actions)
      actions.flat_map(&:grouping_criteria).uniq
    end

    def filter_actions_by_audience(audience, actions)
      actions.group_by(audience)
    end

    def filter_criteria_by_actions(actions, criteria)
      return [] if actions.empty? || criteria.empty?

      action_criteria = actions.flat_map do |action|
        BrexitChecker::Criteria::Extractor.extract(action.criteria).to_a
      end
      criteria_keys = criteria.flat_map(&:key) & action_criteria.uniq
      BrexitChecker::Criterion.load_by(criteria_keys)
    end
  end
end
