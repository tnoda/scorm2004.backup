module Scorm2004
  module Sequencing
    class MeasureRollupProcessTest < ActiveSupport::TestCase
      test 'normally update Objective Information for the activity' do
        activity = stub()
        activity.stubs(:children).returns([child_1, child_2])
        activity.stubs(:rolled_up_objective).returns(rolled_up_objective_to_be_updated)
        process do
          measure_rollup_process(activity: activity)
        end
      end

      test 'for an activity without a rolled-up objective, do nothing' do
        activity = stub(rolled_up_objective: nil)
        assert_equal nil, process { measure_rollup_process(activity: activity) }
      end

      test 'one child does not have its rolled-up objective' do
        activity = stub()
        activity.stubs(:rolled_up_objective).returns(rolled_up_objective_not_to_be_updated)
        activity.stubs(:children).returns([child_0, child_1, child_2])
        assert_equal nil, process { measure_rollup_process(activity: activity) }
      end

      test 'no child contributes to rollup' do
        activity = stub()
        activity.stubs(:rolled_up_objective).returns(rolled_up_objective_to_be_set_false)
        activity.stubs(:children).returns([child_3])
        assert_equal nil, process { measure_rollup_process(activity: activity)}
      end

      private

      def process(&block)
        Process.new(:dummy).instance_eval(&block)
      end

      def rolled_up_objective_to_be_updated
        obj = mock()
        obj.expects(:objective_measure_status=).with(true)
        obj.expects(:objective_normalized_measure=).with(0.3 * 0.5 + 0.7 * 0.8)
        obj
      end

      def rolled_up_objective_not_to_be_updated
        obj = mock()
        obj.expects(:objective_measure_status=).never
        obj.expects(:objective_normalized_measure=).never
        obj
      end

      def rolled_up_objective_to_be_set_false
        obj = mock()
        obj.expects(:objective_measure_status=).with(false)
        obj
      end

      # Does not include a rolled-up objective
      def child_0
        activity = stub(tracked?: true, rolled_up_objective: nil)
      end

      # Rollup Objective Measure Weight = 0.3
      def child_1
        activity = stub()
        activity.stubs(:tracked?).returns(true)
        activity.stubs(:rollup_objective_measure_weight).returns(0.3)
        activity.stubs(:rolled_up_objective).returns(obj_1)
        activity
      end

      # Objective Normalized Measure = 0.5
      def obj_1
        obj = stub()
        obj.stubs(:objective_measure_status).returns(true)
        obj.stubs(:objective_normalized_measure).returns(0.5)
        obj
      end

      # Rollup Objective Measure Weight = 0.7
      def child_2
        activity = stub()
        activity.stubs(:tracked?).returns(true)
        activity.stubs(:rollup_objective_measure_weight).returns(0.7)
        activity.stubs(:rolled_up_objective).returns(obj_2)
        activity
      end

      # Objective Normalized Measure = 0.8
      def obj_2
        obj = stub()
        obj.stubs(:objective_measure_status).returns(true)
        obj.stubs(:objective_normalized_measure).returns(0.8)
        obj
      end

      # Do not contribute to rollup
      def child_3
        stub(tracked?: true, rolled_up_objective: obj_3)
      end

      def obj_3
        stub(objective_measure_status: false)
      end
    end
  end
end
