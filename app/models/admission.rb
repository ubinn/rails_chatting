class Admission < ApplicationRecord
    belongs_to :user
    belongs_to :chat_room, counter_cache: true

    after_commit :user_join_chat_room_notification, on: :create

    def user_join_chat_room_notification
        Pusher.trigger('chat_room', 'join', {chat_room_id: self.chat_room_id, email: self.user.email }.as_json )
        # 어떤 방에 들어가는지. 내가 가지고 있던, 인스턴스의 chat_room_id 넘겨주기
    end
end
