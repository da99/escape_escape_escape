
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
#
# ======================
#
require "uri"
require 'cgi' # Don't use URI.escape because it does not escape all invalid characters.
require "addressable/uri"
# ======================

def Escape_Escape_Escape s
  Escape_Escape_Escape.escape(s)
end

class Escape_Escape_Escape

  INVALID            = Class.new(RuntimeError)
  Unknown_Type       = Class.new(RuntimeError)

  TAG_PATTERN        = /\A[a-z]([a-z0-9\_]{0,}[a-z]{1,})?\z/i

  Underscore_URI_KEY = /_(uri|url|href)$/

  URI_KEY            = /^(uri|url|href)$/

  INVALID_FILE_NAME_CHARS = /[^a-z0-9\_\.]{1,}/i

  TABS           = /\t*/
  TAB            = "\t"
  HTML_TAB       = "&#09;"
  TWO_SPACES     = '  '
  BLANK          = ''
  SPACE          = ' '

  NL             = "\n";
  SPACES         = /\ +/;
  VALID_HTML_ID  = /^[0-9a-z_]+$/i;
  VALID_HTML_TAG = /^[0-9a-z_]+$/i;

  REPEATING_DOTS = /\.{1,}/

  REGEXP_OPTS = Regexp::FIXEDENCODING | Regexp::IGNORECASE

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
  # =====================================================
  MULTI_CONTROL_AND_UNPRINTABLE = /[[:cntrl:]\x00-\x1f&&[^\n[:print:]]]+/i

  # =====================================================


  # =====================================================
  # From:
  # http://www.rubyinside.com/the-split-is-not-enough-whitespace-shenigans-for-rubyists-5980.html
  # =====================================================
  WHITE_SPACE = /[[:space:]&&[^\n]]/
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
      Regexp.new(clean_utf8(str), REGEXP_OPTS)
    end

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
    #
    def clean_utf8 raw_s, *opts

      # === Check options. ==================================================================
      @plaintext_allowed_options ||= [ :spaces, :tabs ]
      invalid_opts = opts - @plaintext_allowed_options
      fail(ArgumentError, "INVALID OPTION: #{invalid_opts.inspect}" ) if !invalid_opts.empty?
      # =====================================================================================

      # === Save tabs if requested.
      raw_s = raw_s.gsub(TAB, HTML_TAB) if opts.include?(:tabs)

      raw_s.
        encode(Encoding.find('utf-8') , ENCODING_OPTIONS_CLEAN_UTF8).
        scrub.
        to_nfkc.
        join(NL).
        gsub(TAB                           , TWO_SPACES).
        gsub(MULTI_CONTROL_AND_UNPRINTABLE , BLANK).
        gsub(WHITE_SPACE                   , SPACE)
    end

    def path raw
      href raw
    end

    # ===============================================
    # :href
    # Inspired from:
    #   http://stackoverflow.com/a/13041565
    # ===============================================
    def href raw_str
      str = clean_utf8(raw_str)
      begin
        uri = URI.parse(str)
        return nil if uri.scheme.downcase['javascript'.freeze]
        return nil if !uri.host && !uri.relative?
        return str unless uri.relative?

        str.split('/').map { |crumb|
          crumb.
            gsub(REPEATING_DOTS, '.').
            gsub(INVALID_FILE_NAME_CHARS, '-').
            to_s
        }.join( '/' )
      rescue URI::InvalidURIError
        nil
      end
    end

    # ===============================================
    # Raises: TZInfo::InvalidTimezoneIdentifier.
    # ===============================================
    def validate_timezone(timezone)
      TZInfo::Timezone.get( timezone.to_s.strip ).identifier
    end

    # ===============================================
    # HTML
    # ===============================================

    def tag( raw_tag )
      return nil unless raw_tag[TAG_PATTERN]
      raw_tag
    end

    def decode_html raw
      EscapeUtils.unescape_html clean_utf8(raw)
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
    def html( raw_text )
      EscapeUtils.escape_html(decode_html(raw_text))
    end # === def html


    # ===============================================
    # Returns: A string that is:
    # * normalized to :KC
    # * "\r\n" changed to "\n"
    # * all control characters stripped except for "\n"
    # and end.
    # Options:
    # :tabs
    # :spaces
    #
    # ===============================================
    def plaintext( raw_str, *opts)



      # Save whitespace or strip.
      if !opts.include?(:spaces)
        final_str = final_str.strip
      end

      # Put back tabs by request.
      if opts.include?(:tabs)
        final_str = final_str.gsub(HTML_TAB, TAB)
      end

      final_str
    end #  === def plaintext

    def escape o, method_name = :html
      if o.kind_of? Hash
        return(
          o.inject({}) { |memo, (k, v)|
            memo[escape(k,method_name)] = escape(v, method_name)
            memo
          }
        )
      end

      if o.is_a?(Symbol)
        result = send(method_name, o.to_s)
        return(result.to_sym) if result.is_a?(String)
        fail Invalid, "#{o} can't be escaped/sanitized."
      end

      return(o.map { |v| escape(v, method_name) }) if o.kind_of? Array
      return send(method_name, o) if o.is_a?(String)
      return o if o == true || o == false || o.kind_of?(Numeric)

      fail Unknown_Type, o.inspect
    end # === def

  end # === class self ===

end # === class Escape_Escape_Escape ===


