module Scorm2004
  module Sequencing
    # [RB.1.1 a]
    # For an activity; may change the Objective Information for the activity.
    class MeasureRollupProcess < Scorm2004::Sequencing::Process
      option :activity

      def run
        # 7.
        # No objective contributes to rollup, so we cannot set anything.
        return unless target_objective

        # 6.1.1.4.1.
        # One of the children does not include a rolled-up objective.
        return unless tracked_children.map(&:rolled_up_objective).all?

        # 6.2.1.
        # No tracking state roll-up, cannot determine the rolled-up measure.
        # 6.3.2.1.
        # No children contributed weight.
        if children_contributing_to_rollup.empty? || counted_measures <= 0.0
          target_objective.objective_measure_status = false
          return
        end

        # 6.3.1.1./6.3.1.2.
        target_objective.objective_measure_status = true
        target_objective.objective_normalized_measure = total_weighted_measure / counted_measures
      end

      private

      def children_contributing_to_rollup
        tracked_children.find_all do |child|
          child.rolled_up_objective.objective_measure_status
        end
      end

      def counted_measures
        tracked_children.find_all(&:rolled_up_objective).inject(0.0) do |memo, child|
          memo + child.rollup_objective_measure_weight
        end
      end

      def total_weighted_measure
        children_contributing_to_rollup.inject(0.0) do |memo, child|
          memo + child.rolled_up_objective.objective_normalized_measure *
            child.rollup_objective_measure_weight          
        end
      end

      def tracked_children
        children.find_all(&:tracked?)
      end

      def target_objective
        activity.rolled_up_objective
      end

      def children
        activity.children
      end
    end
  end
end
