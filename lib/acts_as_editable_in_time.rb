module ActiveRecord
  module Acts
    module EditableInTime
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        attr_accessor :editable_after, :editable_for
        def acts_as_editable_in_time(params = {})
          raise "Invalid :after params : #{params[:after]}" unless %w{create update}.include?(params[:after].to_s)
          raise "You have to specify the duration" if params[:for].blank?
          @editable_after = "#{params[:after]}d_at"
          @editable_for = params[:for]
          include ActiveRecord::Acts::EditableInTime::InstanceMethods
          self.send(:validate, :is_editable, :unless => :new_record?) unless params[:validate] == false
        end
      end

      module InstanceMethods

        def editable?
          (send(self.class.editable_after) > Time.now.utc - self.class.editable_for)
        end

        def is_editable
          errors.add_to_base('not_editable') unless editable?
        end

      end
    end
  end
end