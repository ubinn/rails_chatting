class Admission < ApplicationRecord
    belongs_to :user
    belongs_to :chat_room, counter_cache: true

    after_commit :user_join_chat_room_notification, on: :create
    after_commit :user_exit_chat_room_notification, on: :destroy
    after_commit :user_ready_check, on: :create
    
    

    def user_join_chat_room_notification
        Pusher.trigger("chat_room_#{self.chat_room_id}", 'join', self.as_json.merge({email: self.user.email}) )
        # 어떤 방에 들어가는지. 내가 가지고 있던, 인스턴스의 chat_room_id 넘겨주기
        Pusher.trigger('chat_room','join', self.as_json)
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
