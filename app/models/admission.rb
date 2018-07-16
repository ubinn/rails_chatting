class Admission < ApplicationRecord
    belongs_to :user
    belongs_to :chat_room, counter_cache: true

    after_commit :user_join_chat_room_notification, on: :create
    after_commit :user_exit_chat_room_notification, on: :destroy
    after_commit :user_ready_check, on: :update

    
    
    

    def user_join_chat_room_notification
        current_state = false
        if self.chat_room.max_count == self.chat_room.admissions_count 
            current_state = true
        end
        Pusher.trigger("chat_room_#{self.chat_room_id}", 'join', self.as_json.merge({email: self.user.email}) )
        Pusher.trigger('chat_room','join', self.as_json.merge( {current_state: current_state, max_count: self.chat_room.max_count}))
    end
    
    def user_ready_check
         
        Pusher.trigger("chat_room_#{self.chat_room_id}", 'check_ready', self.as_json.merge({email: self.user.email}) )
        # 어떤 방에 들어가서 ready를 누르는지
    end


    
    def user_exit_chat_room_notification
        Pusher.trigger("chat_room_#{self.chat_room_id}", 'exit', self.as_json.merge({email: self.user.email}))
        Pusher.trigger('chat_room','exit', self.as_json)
    end

    
    
    
end
