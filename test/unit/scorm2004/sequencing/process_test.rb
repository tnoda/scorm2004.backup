require 'test_helper' unless Spork.using_spork?

module Scorm2004
  module Sequencing
    class ProcessTest < ActiveSupport::TestCase
      class FooProcess < Process
        option :bar
        option :baz
      end

      test 'the inherited method defines foo_process' do
        assert Process.new(:dummy).respond_to?(:foo_process)
        FooProcess.expects(:run).with(:dummy, foo: :arg1, bar: :arg2).returns(:run).twice
        assert_equal :run, Process.new(:dummy).foo_process(foo: :arg1, bar: :arg2)
        assert_equal :run, FooProcess.new(:dummy).foo_process(foo: :arg1, bar: :arg2)
      end

      test 'option DSL defines attributes' do
        foo = FooProcess.new(:dummy, bar: 'bar', baz: 'baz')
        assert_equal 'bar', foo.bar
        assert_equal 'baz', foo.baz
      end
    end
  end
end
