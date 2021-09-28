module ProjectHelper
  def new_bugs(project)
    project.bugs.newly
  end

  def started_bugs(project)
    project.bugs.started
  end

  def completed_bugs(project)
    project.bugs.completed 
  end
end
