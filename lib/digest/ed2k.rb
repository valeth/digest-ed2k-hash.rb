# frozen_string_literal: true

require 'digest'
require 'openssl'

module Digest # :nodoc:
    # The ED2K hashing algorithm.
    class ED2K < Digest::Class
        # The ED2K chunk size (9500KB).
        CHUNK_SIZE = 9_728_000

        # Shortcut to the OpenSSL MD4 class.
        MD4 = OpenSSL::Digest::MD4

        # Create a new ED2K hash object.
        #
        # @return  self  to allow method chaining
        def initialize
            @md4 = MD4.new
            reset
        end

        # Hash an IO object.
        #
        # @param   [IO] io  the IO object that will be read
        # @return  self  to allow method chaining
        def io(io)
            while (buf = io.read(CHUNK_SIZE))
                self << buf
            end

            self
        end

        # Calculate the hash of a file.
        #
        # @param   [String] path  the file that will be read
        # @return  self  to allow method chaining
        def file(path)
            io(File.open(path))
        end

        # Reset to the initial state.
        #
        # @return  self  the reset digest object
        def reset
            @md4.reset
            @finalized = false
            @small     = true
            @buf       = ''

            self
        end

        # Rehash with new data.
        #
        # @param  [String] data  the chunk of data to add to the hash
        # @return  self  to allow method chaining
        # @raise  RuntimeError  if the digest object has been finalized
        def update(data)
            raise RuntimeError if @finalized

            @buf += data
            hash

            self
        end

        alias << update

        # Finalize the digest.
        #
        # @param  [String] str  use this string to digest,
        #                       otherwise digest the current md4 hash
        def digest(str = nil)
            if str.nil?
                finish
                @md4.digest
            else
                reset
                self << str
                digest
            end
        end

        # {include:#digest}
        def hexdigest(str = nil)
            if str.nil?
                finish
                @md4.hexdigest
            else
                reset
                self << str
                hexdigest
            end
        end

        # Finalize the hash.
        #
        # @return  self  to allow method chaining
        def finish
            unless @finalized
                @md4 << if @small
                            @buf
                        else
                            MD4.digest(@buf)
                        end

                @finalized = true
            end

            self
        end

        # Shows the current state and the digest class.
        # If the digest is finalized, it shows the hexdigest.
        def inspect
            dig = @finalized ? hexdigest : 'unfinalized'
            "#<#{self.class.name}: #{dig}>"
        end

        class << self
            # Calculate the digest of a string.
            #
            # @param  [String] str  the string to digest
            # @return a finalized digest object
            def digest(str)
                new.digest(str)
            end

            # Calculate the hexdigest of a string.
            # @param  [String] str  the string to digest
            # @return a finalized digest object
            def hexdigest(str)
                new.hexdigest(str)
            end

            # Create a new digest object from a IO object.
            # @param  [IO] io  the IO object to read
            # @return a new digest object
            def io(io)
                new.io(io)
            end

            # Create a new digest object from a file.
            # @param  [String] file the file to read
            # @return a new digest object
            def file(path)
                new.file(path)
            end
        end

        private

        def hash
            while @buf.size >= CHUNK_SIZE
                @small = false
                @md4 << MD4.digest(@buf.slice!(0...CHUNK_SIZE))
            end
        end
    end
end
