class ChatRoom < ApplicationRecord
    has_many :admissions
    has_many :users, through: :admissions
    has_many :chats

    after_commit :create_chat_room_notification, on: :create
    after_commit :delete_chat_room_notification, on: :destroy
    after_commit :update_chat_room_notification, on: :update
    

        
    
    def delete_chat_room_notification
        Pusher.trigger('chat_room','destroy',self.as_json)
    end
    

    def create_chat_room_notification
        Pusher.trigger('chat_room','create',self.as_json)
        #(channel_name, event_name, data를 json형태로// self+().as_json 더 넣고 싶다면 추가로 넣으세염)
    end
    
    def update_chat_room_notification
        Pusher.trigger('chat_room','update', self.as_json)
    end
    
    
    def user_admit_room(user) #인스턴스 메소드
       # chat_room 이 만들어지고 나면, 이 메소드도 같이 실행하라
        Admission.create(user_id: user.id, chat_room_id: self.id)
    end
    
    def user_exit_room(user)
        Admission.where(user_id: user.id, chat_room_id: self.id)[0].destroy
    end
    
    def user_ready(user)
        user_state = Admission.where(user_id: user.id, chat_room_id: self.id)[0]
        user_state.ready_state=true
        user_state.save
    end
end
