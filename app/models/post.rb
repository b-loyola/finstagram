class Post < ActiveRecord::Base
    belongs_to :user
    has_many :comments
    has_many :likes
    
    validates_presence_of :photo_url, :user
    
    def humanized_time_ago
        time_ago_in_seconds = Time.now - self.created_at
        time_ago_in_minutes = time_ago_in_seconds / 60
        
        if (time_ago_in_minutes >= 1440)
            time_ago_in_days = time_ago_in_minutes / 1440
            "#{time_ago_in_days.floor} days ago"
        elsif (time_ago_in_minutes >= 60)
            time_ago_in_hours = time_ago_in_minutes / 60
            "#{time_ago_in_hours.floor} hours ago"
        elsif (time_ago_in_minutes >= 2)
            "#{time_ago_in_minutes.floor} minutes ago"
        else
            "just now"
        end
    end
    
    def like_count
        self.likes.size
    end
    
    def comment_count
        self.comments.size
    end
    
end