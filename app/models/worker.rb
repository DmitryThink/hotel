class Worker < Person
  self.abstract_class = true

  def calculate_salary
    salary * 1.2
  end
end