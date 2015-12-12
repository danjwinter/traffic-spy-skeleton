module TrafficSpy
  class User < ActiveRecord::Base
    validates :identifier, presence: true, uniqueness: true
    has_many :payloads

    def self.pass_save(password, identifier)
      hashed_pass = Digest::SHA1.hexdigest(password)
      User.find_by(identifier: identifier).update(password: hashed_pass)
    end

    def self.secret_question_save(question)
      User.find_by(identifier: identifier).update(question: question)
    end

    def self.secret_answer_save(answer)
      hashed_ans = Digest::SHA1.hexdigest(answer)
      User.find_by(identifier: identifier).update(password: hashed_ans)
    end

    def self.update_password()
  end
end
