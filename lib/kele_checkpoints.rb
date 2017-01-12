module Checkpoints

  def create_submission(checkpoint_id, assignment_branch, assignment_commit_link, comment)

    raise (Kele::NoUserDefined).new if @current_user.nil?

    options = {
      body: {
        "assignment_branch": assignment_branch,
        "assignment_commit_link": assignment_commit_link,
        "checkpoint_id": checkpoint_id,
        "comment": comment,
        "enrollment_id": current_user_enrollment_id
      },

      headers: {
        :authorization => auth_token
      }
    }

    response = self.class.post("/checkpoint_submissions", options)

  end

end
