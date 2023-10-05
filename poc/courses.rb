require 'Faker'

$course_table = []
$course_seq = 0

module POC
  # class Chapter
  class Course
    attr_accessor :id, :name, :lecturer, :description, :chapters

    # chapter: [] of chapter
    def initialize(name, lecturer, description, @chapters)
      @id = $course_seq
      $course_seq += 1
      @name = name
      @lecturer = lecturer
      @description = description
      @chapters = @chapters
    end

    def self.create(name, lecturer, description, @chapters)
      new_course = POC::Course.new(name, lecturer, description, @chapters)
      $course_table << new_course
      new_course
    end

    def self.show(_id)
      c = $course_table.find { |course| course.id == _id }
      puts "c: #{c.inspect}"
      c
    end

    # info is a Hash which stores info about what we want to udpate
    def self.update(id, info)
      idx = $course_table.index { |course| course.id == id }
      course = $course_table[idx]
      info.each do |k, v|
        raise Exception, "In Course,No such attr: #{k}" unless course.respond_to?(k)

        puts "k,v: #{k}, #{v}"

        instance_var_name = "@#{k}"
        course.instance_variable_set(instance_var_name, v)
        # $course_table[idx] = course
      end
    end

    def self.index
      $course_table
    end
  end
end

def main
  10.times do
    new_course = POC::Course.create('Go', 'Russ Cox', 'very good course', [])
    puts "course #{new_course.inspect} is created"
  end

  POC::Course.index
  POC::Course.show(1)

  $course_table[0].name = 'Javascript'

  idxs = $course_table.each_with_index.map do |c, i|
    i
  end
  puts "idxs: #{idxs}"

  name_with_suffix = $course_table.each_with_index.map do |c, i|
    "#{c.name}#{i}"
  end
  puts "namewithsuffix: #{name_with_suffix}"

  POC::Course.update(1, { "name": 'Cpp', "lecturer": 'Alian' })
  POC::Course.update(2, { "name": 'York', "lecturer": 'Alian' })
  POC::Course.show(1)
  POC::Course.show(2)

  # POC::Course.delete(1)
  c = POC::Course.show(1)

end

main
