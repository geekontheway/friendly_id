module FriendlyId
  module Test
    module Shared

      test "finds should respect conditions" do
        with_instance_of(model_class) do |record|
          assert_raises(ActiveRecord::RecordNotFound) do
            model_class.where("1 = 2").find record.friendly_id
          end
        end
      end

      test "should be findable by friendly id" do
        with_instance_of(model_class) {|record| assert model_class.find record.friendly_id}
      end

      test "should be findable by id as integer" do
        with_instance_of(model_class) {|record| assert model_class.find record.id.to_i}
      end

      test "should be findable by id as string" do
        with_instance_of(model_class) {|record| assert model_class.find record.id.to_s}
      end

      test "should be findable by numeric friendly_id" do
        with_instance_of(model_class, :name => "206") {|record| assert model_class.find record.friendly_id}
      end

      test "to_param should return the friendly_id" do
        with_instance_of(model_class) {|record| assert_equal record.friendly_id, record.to_param}
      end

      test "should be findable by themselves" do
        with_instance_of(model_class) {|record| assert_equal record, model_class.find(record)}
      end

      test "updating record's other values should not change the friendly_id" do
        with_instance_of model_class do |record|
          old = record.friendly_id
          record.update_attributes! :active => false
          assert model_class.find old
        end
      end

      test "instances found by a single id should not be read-only" do
        with_instance_of(model_class) {|record| assert !model_class.find(record.friendly_id).readonly?}
      end

      test "failing finds with unfriendly_id should raise errors normally" do
        assert_raises(ActiveRecord::RecordNotFound) {model_class.find 0}
      end

      test "should return numeric id if the friendly_id is nil" do
        with_instance_of(model_class) do |record|
          record.expects(:friendly_id).returns(nil)
          assert_equal record.id.to_s, record.to_param
        end
      end

      test "should return numeric id if the friendly_id is an empty string" do
        with_instance_of(model_class) do |record|
          record.expects(:friendly_id).returns("")
          assert_equal record.id.to_s, record.to_param
        end
      end

      test "should return numeric id if the friendly_id is blank" do
        with_instance_of(model_class) do |record|
          record.expects(:friendly_id).returns("  ")
          assert_equal record.id.to_s, record.to_param
        end
      end
    end
  end
end

