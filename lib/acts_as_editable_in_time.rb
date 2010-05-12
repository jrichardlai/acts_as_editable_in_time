module ActiveRecord
  module Acts #:nodoc:
    module EditableInTime #:nodoc:
      def self.included(base)
        base.extend(ClassMethods)
      end
                
      module ClassMethods
        attr_accessor :editable_after, :editable_for
        def editable(params = {})
          raise "Invalid :after params : #{params[:after]}" unless %w{create update}.include?(params[:after].to_s)
          raise "You have to specify the duration" if params[:for].blank?
          @editable_after = "#{params[:after]}d_at"
          @editable_for = params[:for]
          include ActiveRecord::Acts::EditableInTime::InstanceMethods
          self.send(:validate, :is_editable)
        end
      end

      module InstanceMethods

        def editable?
          (send(self.class.editable_after) > Time.now.utc - self.class.editable_for)
        end

        def is_editable
          errors.add('not_editable') unless editable?
        end

      end
    end
  end
end