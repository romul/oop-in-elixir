defmodule OopTest do
  use OOP.Spec, async: true
  doctest OOP

  oop_test "get students in a non existant grade" do
    school = School.new
    assert [] == school ~> students_by_grade(5)
  end

  oop_test "add student" do
    school = School.new
    school ~>> add_student("Aimee", 2)

    assert ["Aimee"] == school ~> students_by_grade(2)
  end

  oop_test "add students to different grades" do
    school = School.new
    school ~>> add_student("Aimee", 3)
    school ~>> add_student("Beemee", 7)

    assert ["Aimee"] == school ~> students_by_grade(3)
    assert ["Beemee"] == school ~> students_by_grade(7)
  end

  oop_test "grade with multiple students" do
    school = School.new
    grade = 6
    students = ~w(Aimee Beemee Ceemee)
    students |> Enum.each(fn(student) -> school ~>> add_student(student, grade) end)

    assert students == school ~> students_by_grade(grade)
  end

  oop_test "grade with multiple students sorts correctly" do
    school = School.new
    grade = 6
    students = ~w(Beemee Aimee Ceemee)
    students |> Enum.each(fn(student) -> school ~>> add_student(student, grade) end)

    assert Enum.sort(students) == school ~> students_by_grade(grade)
  end

  oop_test "empty students by grade" do
    school = School.new
    assert [] == school ~> all_students
  end

  oop_test "students_by_grade with one grade" do
    school = School.new
    grade = 6
    students = ~w(Beemee Aimee Ceemee)
    students |> Enum.each(fn(student) -> school ~>> add_student(student, grade) end)

    assert [[grade: 6, students: Enum.sort(students)]] == school ~> all_students
  end

  oop_test "students_by_grade with different grades" do
    school = School.new
    everyone |> Enum.each(fn([grade: grade, students: students]) ->
      students |> Enum.each(fn(student) -> school ~>> add_student(student, grade) end)
    end)

    assert everyone_sorted == school ~> all_students
  end

  defp everyone do
    [
      [ grade: 3, students: ~w(Deemee Eeemee) ],
      [ grade: 1, students: ~w(Effmee Geemee) ],
      [ grade: 2, students: ~w(Aimee Beemee Ceemee) ]
    ]
  end

  defp everyone_sorted do
    [
      [ grade: 1, students: ~w(Effmee Geemee) ],
      [ grade: 2, students: ~w(Aimee Beemee Ceemee) ],
      [ grade: 3, students: ~w(Deemee Eeemee) ]
    ]
  end
end
