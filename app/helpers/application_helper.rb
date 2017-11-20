module ApplicationHelper
    include SessionsHelper
    def isLoggedIn?
        return current_user.present?
    end
    
    def isAdmin?
        return (isLoggedIn? && @current_user.role == "admin")
    end
    
    
   # def isUser?
   #     return (isLoggedIn? && @current_user.role == user)
   # end
    
end
