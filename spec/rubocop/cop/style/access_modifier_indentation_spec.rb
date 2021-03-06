# encoding: utf-8

require 'spec_helper'

describe Rubocop::Cop::Style::AccessModifierIndentation, :config do
  subject(:cop) { described_class.new(config) }

  context 'when IndentDepth is set to method' do
    let(:cop_config) { { 'EnforcedStyle' => 'indent' } }

    it 'registers an offence for misaligned private' do
      inspect_source(cop,
                     ['class Test',
                      '',
                      'private',
                      '',
                      '  def test; end',
                      'end'])
      expect(cop.offences.size).to eq(1)
      expect(cop.messages)
        .to eq(['Indent access modifiers like private.'])
    end

    it 'registers an offence for misaligned private in module' do
      inspect_source(cop,
                     ['module Test',
                      '',
                      'private',
                      '',
                      '  def test; end',
                      'end'])
      expect(cop.offences.size).to eq(1)
      expect(cop.messages)
        .to eq(['Indent access modifiers like private.'])
    end

    it 'registers an offence for misaligned private in singleton class' do
      inspect_source(cop,
                     ['class << self',
                      '',
                      'private',
                      '',
                      '  def test; end',
                      'end'])
      expect(cop.offences.size).to eq(1)
      expect(cop.messages)
        .to eq(['Indent access modifiers like private.'])
    end

    it 'registers an offence for misaligned private in class ' +
       'defined with Class.new' do
      inspect_source(cop,
                     ['Test = Class.new do',
                      '',
                      'private',
                      '',
                      '  def test; end',
                      'end'])
      expect(cop.offences.size).to eq(1)
      expect(cop.messages)
        .to eq(['Indent access modifiers like private.'])
    end

    it 'registers an offence for misaligned private in module ' +
       'defined with Module.new' do
      inspect_source(cop,
                     ['Test = Module.new do',
                      '',
                      'private',
                      '',
                      '  def test; end',
                      'end'])
      expect(cop.offences.size).to eq(1)
      expect(cop.messages)
        .to eq(['Indent access modifiers like private.'])
    end

    it 'registers an offence for misaligned protected' do
      inspect_source(cop,
                     ['class Test',
                      '',
                      'protected',
                      '',
                      '  def test; end',
                      'end'])
      expect(cop.offences.size).to eq(1)
      expect(cop.messages)
        .to eq(['Indent access modifiers like protected.'])
    end

    it 'accepts properly indented private' do
      inspect_source(cop,
                     ['class Test',
                      '',
                      '  private',
                      '',
                      '  def test; end',
                      'end'])
      expect(cop.offences).to be_empty
    end

    it 'accepts properly indented protected' do
      inspect_source(cop,
                     ['class Test',
                      '',
                      '  protected',
                      '',
                      '  def test; end',
                      'end'])
      expect(cop.offences).to be_empty
    end

    it 'handles properly nested classes' do
      inspect_source(cop,
                     ['class Test',
                      '',
                      '  class Nested',
                      '',
                      '  private',
                      '',
                      '    def a; end',
                      '  end',
                      '',
                      '  protected',
                      '',
                      '  def test; end',
                      'end'])
      expect(cop.offences.size).to eq(1)
      expect(cop.messages)
        .to eq(['Indent access modifiers like private.'])
    end
  end

  context 'when IndentDepth is set to class' do
    let(:cop_config) { { 'EnforcedStyle' => 'outdent' } }
    let(:indent_msg) { 'Outdent access modifiers like private.' }
    let(:blank_msg) { 'Keep a blank line before and after private.' }

    it 'registers offence for private indented to method depth in a class' do
      inspect_source(cop,
                     ['class Test',
                      '',
                      '  private',
                      '',
                      '  def test; end',
                      'end'])
      expect(cop.offences.size).to eq(1)
      expect(cop.messages).to eq([indent_msg])
    end

    it 'registers offence for private indented to method depth in a module' do
      inspect_source(cop,
                     ['module Test',
                      '',
                      '  private',
                      '',
                      '  def test; end',
                      'end'])
      expect(cop.offences.size).to eq(1)
      expect(cop.messages).to eq([indent_msg])
    end

    it 'registers offence for private indented to method depth in singleton' +
       'class' do
      inspect_source(cop,
                     ['class << self',
                      '',
                      '  private',
                      '',
                      '  def test; end',
                      'end'])
      expect(cop.offences.size).to eq(1)
      expect(cop.messages).to eq([indent_msg])
    end

    it 'registers offence for private indented to method depth in class ' +
       'defined with Class.new' do
      inspect_source(cop,
                     ['Test = Class.new do',
                      '',
                      '  private',
                      '',
                      '  def test; end',
                      'end'])
      expect(cop.offences.size).to eq(1)
      expect(cop.messages).to eq([indent_msg])
    end

    it 'registers offence for private indented to method depth in module ' +
       'defined with Module.new' do
      inspect_source(cop,
                     ['Test = Module.new do',
                      '',
                      '  private',
                      '',
                      '  def test; end',
                      'end'])
      expect(cop.offences.size).to eq(1)
      expect(cop.messages).to eq([indent_msg])
    end

    it 'accepts private indented to the containing class indent level' do
      inspect_source(cop,
                     ['class Test',
                      '',
                      'private',
                      '',
                      '  def test; end',
                      'end'])
      expect(cop.offences).to be_empty
    end

    it 'accepts protected indented to the containing class indent level' do
      inspect_source(cop,
                     ['class Test',
                      '',
                      'protected',
                      '',
                      '  def test; end',
                      'end'])
      expect(cop.offences).to be_empty
    end

    it 'handles properly nested classes' do
      inspect_source(cop,
                     ['class Test',
                      '',
                      '  class Nested',
                      '',
                      '    private',
                      '',
                      '    def a; end',
                      '  end',
                      '',
                      'protected',
                      '',
                      '  def test; end',
                      'end'])
      expect(cop.offences.size).to eq(1)
      expect(cop.messages).to eq([indent_msg])
    end
  end
end
