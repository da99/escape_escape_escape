
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

  Underscore_URI_KEY = /_(uri|url|href)$/
  URI_KEY            = /^(uri|url|href)$/

  INVALID_FILE_NAME_CHARS = /[^a-z0-9\_\.]{1,}/i

  UN_PRINT_ABLE           = /[^[:print:]\n]/

  CR                      = "\r"

  TABS                    = /\t*/
  TAB                     = "\t"
  HTML_TAB                = "&#09;"
  TWO_SPACES              = '  '
  BLANK                   = ''
  SPACE                   = ' '

  REPEATING_DOTS = /\.{1,}/

  CONTROL_CHARS           = /[[:cntrl:]\x00-\x1f]+/  # Don't use "\x20" because that is the space character.


  NL             = "\n";
  SPACES         = /\ +/;
  VALID_HTML_ID  = /^[0-9a-z_]+$/i;
  VALID_HTML_TAG = /^[0-9a-z_]+$/i;

  REGEXP_OPTS = Regexp::FIXEDENCODING | Regexp::IGNORECASE

  # tabs, etc.
  Control = Regexp.new("[[:cntrl:]]".force_encoding('utf-8'), REGEXP_OPTS) # unicode whitespaces, like 160 codepoint

  # From:
  # http://www.rubyinside.com/the-split-is-not-enough-whitespace-shenigans-for-rubyists-5980.html
  WHITE_SPACE = Regexp.new("[[:space:]]&&[^\n]".force_encoding('utf-8'), REGEXP_OPTS)

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

  def new_regexp str
    Regexp.new(clean_utf8(str), REGEXP_OPTS)
  end

  class << self # ======================================================

    # From:
    # http://stackoverflow.com/questions/1268289/how-to-get-rid-of-non-ascii-characters-in-ruby
    #
    # Test:
    # [160, 160,64, 116, 119, 101, 108, 108, 121, 109, 101, 160, 102, 105, 108, 109].
    # inject('', :<<)
    #
    #
    def clean_utf8 s
      s.
        encode(Encoding.find('utf-8') , ENCODING_OPTIONS_CLEAN_UTF8).
        gsub(TAB                      , TWO_SPACES).
        gsub(CR                       , BLANK).
        gsub(UN_PRINT_ABLE            , BLANK).
        gsub(CONTROL_CHARS            , NL ).
        gsub(WHITE_SPACE              , SPACE).
        gsub(Control, NL).split(NL).
        map { |line|
          UNF::Normalizer.normalize(line, :nfkc).
            gsub( CONTROL_CHARS, '' )
        }.join(NL)
    end

    def decode_html raw
      EscapeUtils.unescape_html clean_utf8(raw)
    end

    def e_uri str
      uri = Addressable::URI.parse(str)
      if ["http","https","ftp"].include?(uri.scheme) || uri.path.index('/') == 0
        str
      else
        nil
      end
    rescue Addressable::URI::InvalidURIError
      nil
    end

    def uri str
      uri = Addressable::URI.parse(str)
      if ["http","https","ftp"].include?(uri.scheme) || uri.path.index('/') == 0
        str
      else
        nil
      end
    rescue Addressable::URI::InvalidURIError
      fail "Invalid: address: #{str.inspect}"
    end

    def js_uri raw, name
      name = (name) ? name : 'uri'

      val = string(raw, name)
      if (is_error(val))
        return val
      end

      url   = HTML_E.decode(val, 2);
      parse = URI_js.parse(url);
      if (parse.errors.length)
        return Error(name + ": " + parse.errors[0] + ': ' + val);
      end

      return URI_js.normalize(url);
    end

    # ===============================================
    # Raises: TZInfo::InvalidTimezoneIdentifier.
    # ===============================================
    def validate_timezone(timezone)
      TZInfo::Timezone.get( timezone.to_s.strip ).identifier
    end

    # =========================================================
    # Takes out any periods and back slashes in a String.
    # Single periods surround text are allowed on the last substring
    # past the last slash because they are assumed to be filenames
    # with extensions.
    # =========================================================
    def path( raw_path )
      clean_crumbs = raw_path.split('/').map { |crumb| filename(crumb) }
      File.join( *clean_crumbs )
    end

    # ====================================================================
    # Returns a String where all characters except:
    # letters numbers underscores dashes
    # are replaced with a dash.
    # It also delets any non-alphanumeric characters at the end
    # of the String.
    # ====================================================================
    def filename( raw_filename )
      plaintext( raw_filename ).
        downcase.
        gsub(REPEATING_DOTS, '.').
        gsub(INVALID_FILE_NAME_CHARS, '-').
        to_s
    end

    # ===============================================
    # This method is not meant to be called directly. Instead, call
    # <Wash.parse_tags>.
    # Returns: String with
    # * all spaces and underscores turned into dashes.
    # * all non-alphanumeric characters, underscores, dashes, and periods
    # turned into dashes.
    # * non-alphanumeric characters at the beginning and end stripped out.
    # ===============================================
    def tag( raw_tag )
      # raw_tag.strip.downcase.gsub( /[^a-z0-9\.]{1,}/,'-').gsub(/^[^a-z0-9]{1,}|[^a-z0-9]{1,}$/i, '').gsub(/\.{1,}/, '.')
      raw_tag.strip.downcase.gsub(/^[\,\.]{1,}|[\"]{1,}|[\,\.]{1,}$/, '').gsub(/\ /, '-')
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

      # Check options.
      @plaintext_allowed_options ||= [ :spaces, :tabs ]
      invalid_opts = opts - @plaintext_allowed_options
      fail(ArgumentError, "INVALID OPTION: #{invalid_opts.inspect}" ) if !invalid_opts.empty?

      # Save tabs if requested.
      raw_str = raw_str.gsub(TAB, HTML_TAB) if opts.include?(:tabs)

      # First: Normalize characters.
      # Second: Strip out control characters.
      # Note: Must be normalized first, then strip.
      # See: http://msdn.microsoft.com/en-us/library/dd374126(v=vs.85).aspx
      # See: http://www.unicode.org/faq/normalization.html
      final_str = clean_utf8(raw_str)

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

    def escape o, key = nil
      return(o.map { |v| escape(v) }) if o.kind_of? Array

      if o.kind_of? Hash
        new_o = {}

        o.each { |k, v| new_o[escape(k)] = escape(v, k) }

        return new_o
      end

      if o.is_a?(String)
        o = html(decode_html(o))
        return _e(o, key)
      end

      if o.is_a?(Symbol)
        return _e(o.to_s).to_sym
      end

      if o == true || o == false || o.kind_of?(Numeric)
        return o
      end

      raise "Unknown type: #{o.class}"
    end # === def

  end # === class self ===

end # === class Escape_Escape_Escape ===


