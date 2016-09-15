ExUnit.start()

import OOP.Def
defclass School do

  fields db: %{}

  initialize do
    this
  end

  defproc add_student(name, grade) do
    new_db = Map.update(this.db, grade, [name], &([name|&1]))
    this = Map.put(this, :db, new_db)
  end

  defmethod show do
    this.db
  end

  defmethod students_by_grade(grade) do
    students = this.db |> Map.get(grade, [])
    students |> Enum.sort
  end

  defmethod all_students do
    this.db
    |> Map.keys
    |> Enum.map(fn(grade) ->
      [grade: grade, students: get_students_by_grade(this.db, grade)]
    end)
  end


  # Private functions

  defp get_students_by_grade(db, grade) do
    Map.get(db, grade, []) |> Enum.sort
  end
end
