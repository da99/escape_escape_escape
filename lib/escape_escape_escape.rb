
require 'unf'

require "escape_utils"

require 'escape_utils/html/rack' # to patch Rack::Utils
require 'escape_utils/html/erb' # to patch ERB::Util
require 'escape_utils/html/cgi' # to patch CGI
require 'escape_utils/html/haml' # to patch Haml::Helpers

require 'escape_utils/url/cgi' # to patch CGI
require 'escape_utils/url/erb' # to patch ERB::Util
require 'escape_utils/url/rack' # to patch Rack::Utils
require 'escape_utils/url/uri' # to patch URI

# ======================
require "htmlentities"
# ======================
#
require "uri"
require 'cgi' # Don't use URI.escape because it does not escape all invalid characters.
require "addressable/uri"
# ======================

require 'oj'
require 'multi_json'

Oj.default_options = {:mode=>:strict}




def Escape_Escape_Escape s
  Escape_Escape_Escape.escape(s)
end

class Escape_Escape_Escape

  # === From sanitize gem:
  #   https://raw.githubusercontent.com/rgrove/sanitize/master/lib/sanitize.rb
  REGEX_UNSUITABLE_CHARS = /[\u0340\u0341\u17a3\u17d3\u2028\u2029\u202a-\u202e\u206a-\u206f\ufff9-\ufffb\ufeff\ufffc\u{1d173}-\u{1d17a}\u{e0000}-\u{e007f}]/u
  # ==================================================================================

  CODER              = HTMLEntities.new(:xhtml1)

  Invalid               = Class.new(StandardError)
  Invalid_HREF          = Class.new(Invalid)
  Invalid_Relative_HREF = Class.new(Invalid_HREF)
  Invalid_Type          = Class.new(Invalid)

  TAG_PATTERN        = /\A[a-z]([a-z0-9\_]{0,}[a-z]{1,})?\z/i

  VALID_CSS_VALUE      = /\A[a-z0-9\;\-\_\#\ ]+\z/i
  VALID_CSS_SELECTOR   = /\A[a-z0-9\#\:\_\-\.\ ]+\z/i
  VALID_CSS_ATTR       = /\A[a-z0-9-]+\z/i
  VALID_CSS_CLASS_NAME = /\A[a-z0-9\_]+\z/i

  VALID_HTML_ID  = /\A[0-9a-z_]+\z/;
  VALID_HTML_TAG = /\A[a-z][0-9a-z_]*\z/;

  INVALID_FILE_NAME_CHARS = /[^a-z0-9\_\.]{1,}/i

  TABS           = /\t*/
  TAB            = "\t"
  HTML_TAB       = "&#09;"
  TWO_SPACES     = '  '
  BLANK          = ''
  SPACE          = ' '

  NL             = "\n";
  SPACES         = /\ +/;

  REPEATING_DOTS = /\.{1,}/

  # === MULTI_CONTROL_CHARS: ==================================
  #
  # Unicode whitespaces, like 160 codepoint, tabs, etc.
  # Excludes newline.
  #
  # Examples:
  #   \r\n \r\n -> \n \n
  #
  # NOTE: Don't use "\x20" because that is the space character.
  #
  # Whitespace regex ([:space:]) from:
  #   http://www.rubyinside.com/the-split-is-not-enough-whitespace-shenigans-for-rubyists-5980.html
  #
  # =====================================================
  MULTI_CONTROL_AND_UNPRINTABLE = /[[:space:][:cntrl:]\x00-\x1f&&[^\n\ [:print:]]]+/i
  # =====================================================

  ENCODING_OPTIONS_CLEAN_UTF8 = {
    :invalid           => :replace, # Replace invalid byte sequences
    :undef             => :replace, # Replace anything not defined in ASCII
    :replace           => '' # Use a blank for those replacements
    # :universal_newline => true # Always break lines with \n, not \r\n
    #   -- this is not working with :replace, so it has to be done manually
    #      with .gsub
  }

  CONFIG = {
    :protocols => {
      "a"=>{
        "href"=>["ftp", "http", "https", "mailto", :relative]
      },
      "img"=>{
        "src"=>["http", "https", :relative]
      }
    }
  }

  class << self # ======================================================

    def regexp str
      @regexp_opts ||= Regexp::FIXEDENCODING | Regexp::IGNORECASE
      Regexp.new(clean_utf8(str), @regexp_opts)
    end

    # ===============================================
    # Raises: TZInfo::InvalidTimezoneIdentifier.
    # ===============================================
    def validate_timezone(timezone)
      TZInfo::Timezone.get( timezone.to_s.strip ).identifier
    end

    # ==================================================================
    # * normalized to :KC
    # * "\r\n" changed to "\n"
    # * all control characters stripped except for "\n"
    # and end.
    # Normalization, then strip:
    #   http://msdn.microsoft.com/en-us/library/dd374126(v=vs.85).aspx
    #   http://www.unicode.org/faq/normalization.html
    #
    # Getting rid of non-ascii characters in ruby:
    # http://stackoverflow.com/questions/1268289/how-to-get-rid-of-non-ascii-characters-in-ruby
    #
    # Test:
    # [160, 160,64, 116, 119, 101, 108, 108, 121, 109, 101, 160, 102, 105, 108, 109].
    # inject('', :<<)
    #
    # Options:
    #
    #   :tabs
    #   :spaces
    #
    def clean_utf8 raw_s, *opts

      fail("Not a string: #{raw_s.inspect}") unless raw_s.is_a?(String)

      # === Check options. ==================================================================
      @plaintext_allowed_options ||= [ :spaces, :tabs ]
      invalid_opts = opts - @plaintext_allowed_options
      fail(ArgumentError, "INVALID OPTION: #{invalid_opts.inspect}" ) if !invalid_opts.empty?
      # =====================================================================================

      raw_s = raw_s.dup

      # === Save tabs if requested.
      raw_s.gsub!(TAB, HTML_TAB) if opts.include?(:tabs)

      raw_s.encode!(Encoding.find('utf-8') , ENCODING_OPTIONS_CLEAN_UTF8)
      raw_s.scrub!
      raw_s.gsub!(TAB                           , TWO_SPACES)
      raw_s.gsub!(MULTI_CONTROL_AND_UNPRINTABLE , BLANK)
      raw_s.gsub!(REGEX_UNSUITABLE_CHARS        , ' ')

      clean = raw_s.to_nfkc

      # Save whitespace or strip.
      if !opts.include?(:spaces)
        clean.strip!
      end

      # Put back tabs by request.
      if opts.include?(:tabs)
        clean.gsub!(HTML_TAB, TAB)
      end

      clean
    end

    # ===============================================
    #
    # Handles urls and relative paths.
    #
    # Inspired from:
    #   http://stackoverflow.com/a/13041565
    #
    # ===============================================
    alias_method :path, def href raw_str
      fail("Not a string: #{raw_str.inspect}") unless raw_str.is_a?(String)

      begin
        uri = URI.parse(decode_html(raw_str))
        if uri.scheme
          uri.scheme = uri.scheme.to_s.strip.downcase
        end

        fail( Invalid_HREF, "javascript:// is not allowed" ) if (uri.scheme || ''.freeze)['javascript'.freeze]
        fail( Invalid_HREF, "address is invalid") if !uri.host && !uri.relative?

        html(EscapeUtils.escape_uri uri.to_s)
      rescue URI::InvalidURIError => e
        raise Invalid_HREF, e.message
      end
    end

    def relative_href raw_str
      str = Escape_Escape_Escape.decode_html href(raw_str)
      uri = URI.parse(str)
      fail( Invalid_Relative_HREF, "Is not relative: #{str}" ) if uri.scheme

      Escape_Escape_Escape.html str
    end

    # ===============================================
    # HTML
    # ===============================================

    def tag( raw_tag )
      return nil unless raw_tag[TAG_PATTERN]
      raw_tag
    end

    def decode_html raw
      fail("Not a string: #{raw.inspect}") unless raw.is_a?(String)
      CODER.decode clean_utf8(raw)
    end

    %w{attr selector value}.each { |name|
      eval <<-EOF, nil, __FILE__, __LINE__ + 1
        def css_#{name} raw
          fail(Invalid_Type, "Not a string: \#{raw.inspect}") unless raw.is_a?(String)
          clean = html(raw)
          return clean if clean[VALID_CSS_#{name.upcase}]
          fail Invalid, "contains invalid chars: \#{raw.inspect}"
        end
      EOF
    }

    def css_class_name val
      return val if val.is_a?(String) && val[VALID_CSS_CLASS_NAME]
      fail(Invalid, "CSS class name: #{val.inspect}")
    end

    # ===============================================
    # A better alternative than "Rack::Utils.escape_html". Escapes
    # various characters (including '&', '<', '>', and both quotation mark types)
    # to HTML decimal entities. Also escapes the characters from
    # <HTML_ESCAPE_TABLE>.
    #
    # Text has to be UTF-8 before encoding, according to HTMLEntities gem.
    # Therefore, all text is run through <plaintext> before encoding.
    # ===============================================
    def html raw_text
      EscapeUtils.escape_html(decode_html(raw_text))
    end # === def html

    def html_tag raw_o
      case raw_o
      when String, Symbol
        str = raw_o.to_s.downcase
        return str.to_sym if str[VALID_HTML_TAG]
        raise Invalid, "Invalid chars: #{raw_o.inspect}"
      else
        fail TypeError, "Not a String or Symbol: #{raw_o.inspect}"
      end
    end

    def html_id raw_o
      case raw_o
      when String, Symbol
        str = raw_o.to_s.downcase
        return str.to_sym if str[VALID_HTML_ID]
        raise Invalid, "Invalid chars: #{raw_o.inspect}"
      else
        fail TypeError, "Not a String or Symbol: #{raw_o.inspect}"
      end
    end

    def escape o, method_name = :html
      if o.kind_of? Hash
        return(
          o.inject({}) { |memo, (k, v)|
            memo[escape(k,method_name)] = escape(v, method_name)
            memo
          }
        )
      end

      return(send(method_name, o.to_s).to_sym) if o.is_a?(Symbol)
      return(o.map { |v| escape(v, method_name) }) if o.kind_of? Array
      return send(method_name, o) if o.is_a?(String)
      return send(method_name, o.to_s) if o == true || o == false || o.kind_of?(Numeric)

      fail Invalid, "Not a String, Number, Array, or Hash"
    end # === def

    def json_encode o
      case o
      when Array
        Oj.dump(o, mode: :strict)
      else
        fail Invalid, "Not an Array: #{o.inspect}"
      end
    end

    def json_decode o
      case o
      when String
        Oj.strict_load clean_utf8(o)
      else
        fail Invalid, "Not a String: #{o.inspect}"
      end
    end

  end # === class self ===

end # === class Escape_Escape_Escape ===


