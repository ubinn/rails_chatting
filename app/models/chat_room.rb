class ChatRoom < ApplicationRecord
    has_many :admissions
    has_many :users, through: :admissions
    has_many :chats

    after_commit :create_chat_room_notification, on: :create
    
    def create_chat_room_notification
        Pusher.trigger('chat_room','create',self.as_json)
        #(channel_name, event_name, data를 json형태로// self+().as_json 더 넣고 싶다면 추가로 넣으세염)
    end
    
    
    def user_admit_room(user) #인스턴스 메소드
       # chat_room 이 만들어지고 나면, 이 메소드도 같이 실행하라
        Admission.create(user_id: user.id, chat_room_id: self.id)
    end
end
