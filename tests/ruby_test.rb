# typed: true
# frozen_string_literal: true

module Result
  class Test
    def initialize(str)
      str
    end
  end
end

module SorbetTest
  class Sorbet
    extend(T::Sig)

    sig { params(test: String).returns(Result::Test) }
    def method(test: "hello")
      Result::Test.new("string")
    end

    sig {
      params(test: String).void
    }
    def method2(test: "hello")
    end

    sig { void }
    def method3
    end

    sig { returns(Result::Test) }
    def method4
      Result::Test.new("string")
    end

    sig do
      returns(Result::Test)
    end
    def method5
      Result::Test.new("string")
    end

    sig do
      void
    end
    def method6
    end

    sig do
      params(test: String).returns(Result::Test)
    end
    def method7(test: "string")
      Result::Test.new('test')
    end

    sig do
      returns(Result::Test)
    end
    def method8
      Result::Test.new('test')
    end
  end
end
