# Update Bundles Script

## Todo

* Passes in an array of paths
* Rake task invoke on each path in the array
* Aborts on failures

## Changing the Directory

[ruby - Temporarily change current directory in Rake - Stack Overflow](http://stackoverflow.com/questions/16533571/temporarily-change-current-directory-in-rake):

>		Dir.chdir('.git') do
>			File.unlink('config')
>		end

> If a block is given, it is passed the name of the new current directory, and the block is executed with that as the current directory. The original working directory is restored when the block exits.

##  Passing in Arguments

[ruby on rails - Passing a parameter or two to a Rake task - Stack Overflow](http://stackoverflow.com/questions/5207435/passing-a-parameter-or-two-to-a-rake-task):

>		<prompt> rake db:do_something[1,2]
>
> I've added a second parameter to show that you'll need the comma, but omit any spaces.
> 
> And define it like this:
> 
>		task :do_something :arg1, :arg2 do |t, args|
>		  args.with_defaults(:arg1 => "default_arg1_value", :arg2 => "default_arg2_value")
>		  # args[:arg1] and args[:arg2] contain the arg values, subject to the defaults
>		end

## Arguments that are dependencies

[ruby - Rails Rake: How to pass in arguments to a task with :environment - Stack Overflow](http://stackoverflow.com/questions/1357639/rails-rake-how-to-pass-in-arguments-to-a-task-with-environment):

> Just to follow up on this old topic; here's what I think a current Rakefile (since a long ago) should do there. It's an upgraded and bugfixed version of the current winning answer (hgimenez):
> 
>		desc "Testing environment and variables"
>		task :hello, [:message]  => :environment  do |t, args|
>		  args.with_defaults(:message => "Thanks for logging on")
>		  puts "Hello #{User.first.name}. #{args.message}"   # Q&A above had a typo here : #{:message}
>		end
> This is how you invoke it:
> 
>		  rake hello[World]
>
> For multiple arguments, just add their keywords in the array of the task declaration (task :hello, [:a,:b,:c]...), and pass them comma separated:
> 
>		  rake hello[Earth,Mars,Sun,Pluto]

## Bailing from Tasks Early

[ruby - How do I return early from a rake task? - Stack Overflow](http://stackoverflow.com/questions/2316475/how-do-i-return-early-from-a-rake-task)

Use `abort` or `next`

## Parameters

[ruby - How do I pass command line arguments to a rake task? - Stack Overflow](http://stackoverflow.com/questions/825748/how-do-i-pass-command-line-arguments-to-a-rake-task)

> 		task :invoke_my_task do
> 		  Rake.application.invoke_task("my_task[1, 2]")
> 		end
> 		
> 		# or if you prefer this syntax...
> 		task :invoke_my_task_2 do
> 		  Rake::Task[:my_task].invoke(3, 4)
> 		end
