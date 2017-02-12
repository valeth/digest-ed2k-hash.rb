# frozen_string_literal: true

require 'spec_helper'

# verified with rhash (https://github.com/rhash/RHash)
TESTFILES = {
    '3d8a6f73694a87143dfec4e402462d0e' => './spec/testfiles/9718500b',
    '26c8ef4bca129c4a9574a9782c0e8695' => './spec/testfiles/9728000b',
    '929483f338c061fcef48b1d5cbacfe18' => './spec/testfiles/9737500b'
}.freeze

describe Digest::ED2K do
    TESTFILES.each do |hash, path|
        it "hashes file #{path}" do
            expect(Digest::ED2K.file(path).hexdigest).to eq(hash)
        end
    end
end
