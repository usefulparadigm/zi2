class OpenLevel
  PRIVATE=1
  FRIENDS_ONLY=2
  MEMBERS_ONLY=3
  PUBLIC=99
  
  def self.options
    [['비밀글', PRIVATE], ['지인공개', FRIENDS_ONLY], ['회원공개', MEMBERS_ONLY], ['전체공개', PUBLIC]]
  end
end