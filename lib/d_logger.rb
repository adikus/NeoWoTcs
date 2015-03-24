class DLogger < ActiveSupport::Logger
	def initialize(*)
		@tag = nil
		super
	end

	def tag(tag)
		@tag = tag.blank? ? nil : "[#{tag}] "
		yield self
	ensure
		@tag = nil
	end

	# Create wrappers around Rails logger API
	%i{debug info warn error fatal}.each do |method|
		define_method(method) do |message = nil|
			# Support both .info(msg) and .info { msg } form
			if block_given?
				message = yield
			end

			super(tag_message(message))
		end
	end

	def exception(e, args = {})
		case args
			when Hash
				message = args[:message]
			when String
				# Allow `logger.exception(exception, "Something went wrong here")`
				message = args
			else
				raise ArgumentError
		end
		raise ArgumentError unless e.is_a?(Exception)

		error(message) if message
		error(e.message) if e.message
		error(e.backtrace.join("\n")) if e.backtrace
	end

	def validation_error(model, message = '')
		message += ' | ' if message.present?
		error("#{message}#{model.class}: #{model.errors.full_messages.join('. ')}.")
	end

	private

	def tag_message(message)
		if @tag.blank?
			message
		else
			"#{@tag}#{message}"
		end
	end
end
