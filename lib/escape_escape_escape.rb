

require "sanitize"

class Escape_Escape_Escape

  REPEATING_DOTS          = /\.{1,}\//
  INVALID_FILE_NAME_CHARS = /[^a-z0-9\_\.]{1,}/i
  UN_PRINT_ABLE           = /[^[:print:]\n]/
  CR                      = "\r"
  TABS                    = "\t"
  CONTROL_CHARS           = /[[:cntrl:]\x00-\x1f]/  # Don't use "\x20" because that is the space character.
  WHITE_SPACE             = /[[:space:]]&&[^\n]/            # http://www.rubyinside.com/the-split-is-not-enough-whitespace-shenigans-for-rubyists-5980.html

  ENCODING_OPTIONS_CLEAN_UTF8 = {
    :invalid           => :replace, # Replace invalid byte sequences
    :undef             => :replace, # Replace anything not defined in ASCII
    :replace           => '' # Use a blank for those replacements
    # :newline         => :universal
    # :universal_newline => true # Always break lines with \n, not \r\n
  }



  class << self # ======================================================

    # From:
    # http://stackoverflow.com/questions/1268289/how-to-get-rid-of-non-ascii-characters-in-ruby
    #
    # Test:
    # [160, 160,64, 116, 119, 101, 108, 108, 121, 109, 101, 160, 102, 105, 108, 109].
    # inject('', :<<)
    #
    def clean_utf8 s
      s.
        encode(Encoding.find('utf-8') , ENCODING_OPTIONS_CLEAN_UTF8).
        gsub(TABS                     , "  ").
        gsub(CR                       , "").
        gsub(UN_PRINT_ABLE            , '').
        gsub(CONTROL_CHARS            , "\n" ).
        gsub(WHITE_SPACE              , " ")
    end

    def text s
      clean_utf8 s
    end

    def html s
      Sanitize.fragment( clean_utf8(s), Sanitize::Config::RELAXED )
    end

  end # === class self ===

end # === class Escape_Escape_Escape ===


