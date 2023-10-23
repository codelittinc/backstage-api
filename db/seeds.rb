# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# Professions
if Profession.count.zero?
  Profession.create(name: 'Engineer')
  Profession.create(name: 'Quality Assurance Specialist')
  Profession.create(name: 'Designer')
  Profession.create(name: 'UX Researcher')
end

# Skills

if Skill.count.zero?
  Skill.create(name: 'React')
  Skill.create(name: 'Ruby on Rails')
  Skill.create(name: 'Ruby')
  Skill.create(name: 'Javascript')
end
