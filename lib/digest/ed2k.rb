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
            self << io
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

            self
        end

        # Rehash with new data.
        #
        # @param  [String, IO] data  the chunk of data to add to the hash
        # @return  self  to allow method chaining
        # @raise  RuntimeError  if the digest object has been finalized
        def update(data)
            raise RuntimeError if @finalized

            # get the IO object
            buf = to_io(data)

            # if the chunk is smaller than CHUNK_SIZE just return the MD4 hash
            if buf.size < CHUNK_SIZE
                @md4 << buf.read
            else
                # read chunks from the IO object and update the MD4 hash
                while (chunk = buf.read(CHUNK_SIZE))
                    @md4 << MD4.digest(chunk)
                end

                # weird EDonkey bug requires multiples of CHUNK_SIZE
                # to append one additional MD4 hash
                @md4 << MD4.new.digest if multiple?(buf.size)
            end

            self
        end

        alias << update

        # Finalize the hash and return the digest.
        #
        # If no string is provided, the current hash is used
        #
        # @param  [String, IO] data  hash this chunk of data
        def digest(data = nil)
            if data.nil?
                finish
                @md4.digest
            else
                reset
                self << data
                digest
            end
        end

        # Finalize the hash and return the hexdigest.
        #
        # If no string is provided, the current hash is used
        #
        # @param  [String, IO] data  hash this chunk of data
        def hexdigest(data = nil)
            if data.nil?
                finish
                @md4.hexdigest
            else
                reset
                self << data
                hexdigest
            end
        end

        # Finalize the hash.
        #
        # @return  self  to allow method chaining
        def finish
            @finalized = true unless @finalized

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
            # @param  [String, IO] data  the string to digest
            # @return a finalized digest object
            def digest(data)
                new.digest(data)
            end

            # Calculate the hexdigest of a string.
            #
            # @param  [String, IO] data  the string to digest
            # @return a finalized digest object
            def hexdigest(data)
                new.hexdigest(data)
            end

            # Create a new digest object from a IO object.
            #
            # @param  [IO] io  the IO object to read
            # @return a new digest object
            def io(io)
                new.io(io)
            end

            # Create a new digest object from a file.
            #
            # @param  [String] path  the file to read
            # @return a new digest object
            def file(path)
                new.file(path)
            end
        end

        private

        def to_io(obj)
            if obj.is_a? String
                StringIO.new(obj)
            elsif obj.is_a? IO
                obj
            else
                raise ArgumentError, "cannot hash #{obj.class.name} object"
            end
        end

        def multiple?(buf_size)
            (buf_size % CHUNK_SIZE).zero?
        end
    end
end
