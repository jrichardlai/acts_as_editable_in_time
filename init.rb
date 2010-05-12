require 'acts_as_editable_in_time'

ActiveRecord::Base.send(:include, ActiveRecord::Acts::EditableInTime)