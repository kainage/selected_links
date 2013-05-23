module SelectedLinks
	class Link
		attr_reader :name, :options, :html_options
		attr_accessor :source

		def initialize(*args, &block)
			@name, @options, @html_options = parse_args(block_given?, *args)
			@matcher = @html_options[:matcher]
			@source = @html_options[:source]
		end

		def generate
			merge_classes if is_match?
			cleanup

			self
		end

		private

		def parse_args(block, *args)
			if block
				[nil, args.first, args.second || {}]
			else
				[args[0], args[1], args[2] || {}]
			end
		end

		def merge_classes
			@html_options.merge!({class: 'selected'}) { |key, old_v, new_v| [old_v, new_v].join(' ') }
		end

		def is_match?
			url_match?(@source, @matcher) || url_match?(@source, @name)
		end

		def url_match?(source, matcher)
			return false unless matcher # nil.to_s returns ""
			source =~ /#{matcher}/i
		end

		def cleanup
			remove_matcher
			remove_source
		end

		def remove_matcher
			@html_options.delete(:matcher)
		end

		def remove_source
			@html_options.delete(:source)
		end
	end
end
