module IWorker

  def calculate_salary
    raise NotImplementedError, "Subclasses must define `calculate_salary`."
  end
end