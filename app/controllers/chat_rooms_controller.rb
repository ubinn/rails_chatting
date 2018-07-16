class ChatRoomsController < ApplicationController
  before_action :set_chat_room, only: [:show, :edit, :update, :destroy, :user_admit_room, :chat, :user_exit_room,:is_user_ready]
  before_action :authenticate_user!, except: [:index]
  # user_signed_in? 은 안돼 redirect가 안되기 때문에

  # GET /chat_rooms
  # GET /chat_rooms.json
  def index
    @chat_rooms = ChatRoom.all
    
  end

  # GET /chat_rooms/1
  # GET /chat_rooms/1.json
  def show
    unless current_user.joined_room?(@chat_room)
      @chat_room.user_admit_room(current_user)
    end
     if @chat_room.admissions_count > 0
        
     else 
       @chat_room.destroy()
       redirect_to root_path
     end 
  end

  # GET /chat_rooms/new
  def new
    @chat_room = ChatRoom.new
  end

  # GET /chat_rooms/1/edit
  def edit
  end

  # POST /chat_rooms
  # POST /chat_rooms.json
  def create
    @chat_room = ChatRoom.new(chat_room_params)
    @chat_room.master_id = current_user.email
# @chat_room 이 인스턴스
    respond_to do |format|
      if @chat_room.save
        @chat_room.user_admit_room(current_user)
        format.html { redirect_to @chat_room, notice: 'Chat room was successfully created.' }
        format.json { render :show, status: :created, location: @chat_room }
      else
        format.html { render :new }
        format.json { render json: @chat_room.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /chat_rooms/1
  # PATCH/PUT /chat_rooms/1.json
  def update
  
    respond_to do |format|
      if @chat_room.update(chat_room_params)
        format.html { redirect_to @chat_room, notice: 'Chat room was successfully updated.' }
        format.json { render :show, status: :ok, location: @chat_room }
      else
        format.html { render :edit }
        format.json { render json: @chat_room.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /chat_rooms/1
  # DELETE /chat_rooms/1.json
  def destroy
    @chat_room.destroy
    respond_to do |format|
      format.html { redirect_to chat_rooms_url, notice: 'Chat room was successfully destroyed.' }
      
    end
    
  end
  
  # def user_admit_room
  #   # 현재 유저가 있는 방에서 join버튼을 눌렀을때 동작하는 액션
  #   if current_user.joined_room?(@chat_room)
  #     render js: "alert('이미 참여한 방입니다');"
  #   else
  #     @chat_room.user_admit_room(current_user)
  #   end
  # end
  
  def is_user_ready
    if current_user.is_ready?(@chat_room)
      render js: "console.log('이미레디상태');"
    else
      # @chat_room.admissions.where(user_id: currnet_user.id)[0].ready_state
      @chat_room.user_ready(current_user)
      render js: "console.log('레디로 바꼈습니다.');"
      
      # 현재 레디한 방 외에 모든 방의 레디상태해제
      current_user.admissions.where.not(chat_room_id: @chat_room.id).destroy_all
    end
  end
  
  
  def user_exit_room 
    # chat_room 에 인스턴스 메소드로 사용된다 user_exit_room이 
    @chat_room.user_exit_room(current_user)
    if @chat_room.admissions_count <= 1
      @chat_room.destroy()
    end
      
  end
  
  def chat
    @chat_room.chats.create(user_id: current_user.id, message: params[:message])
  end
  
  # def room_status_change
  #   if @chat_room.admissions_count  == @chat_room.max_count
  #     @chat_room.room_status = true
  #   end  
  # end



  private
    # Use callbacks to share common setup or constraints between actions.
    def set_chat_room
      @chat_room = ChatRoom.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def chat_room_params
      params.fetch(:chat_room, {}).permit(:title, :max_count)
    end
end
