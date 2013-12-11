module SelectedLinks
  class Link
    attr_reader :name, :options, :html_options
    attr_accessor :source

    def initialize(*args, &block)
      @name, @options, @html_options = parse_args(block_given?, *args)
      @matcher    = @html_options.delete(:matcher)
      @source     = @html_options.delete(:source)
      @class_name = @html_options.delete(:class_name)
    end

    def generate
      merge_classes if is_match?
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
      name = @class_name || SelectedLinks.default_class_name
      @html_options.merge!({class: name}) { |key, old_v, new_v| [old_v, new_v].join(' ') }
    end

    def is_match?
      # Always return true if the source and the matcher match.
      return true if url_match?(@source, @matcher)
      # If not check for fallback and presence of @matcher and check again if necessary.
      if (@matcher && SelectedLinks.fallback_to_name) || !@matcher
        return url_match?(@source, @name)
      else
        return false
      end
    end

    def url_match?(source, matcher)
      return false unless matcher # nil.to_s returns ""
      source =~ /#{matcher}/i
    end
  end
end
