defmodule HL7 do
  @moduledoc """
  Main module of the **ex_hl7** library.
  """
  alias HL7.{Codec, Message, Reader, Segment, Type, Writer}
  require Record

  @schema [ :"Person", :"Patient", :"Location", :"Organization",
            :"Composition",
            :"DeviceDefinition", :"DeviceDispense", :"DeviceRequest" ]

  Enum.each(@schema,
    fn t ->
      Enum.each(
        Record.extract_all(
          from_lib: "hl7/include/" <> :erlang.list_to_binary(:erlang.atom_to_list(t)) <> ".hrl"
        ),
        fn {name, definition} ->
          prev = :application.get_env(:kernel, :hl7_tables, [])
          prev2 = :application.get_env(:hl7, :hl7_fields, [])
          case :lists.member(name, prev) do
            true ->
              :skip

            false ->
              Record.defrecord(name, definition)
              :application.set_env(:kernel, :hl7_tables, [name | prev])
              :application.set_env(:hl7, :hl7_fields, [{name,definition} | prev2])
          end
        end
      )
    end
  )

  def schema(), do: @schema

  def testReader() do
      msg =
      "MSH|^~\\&|CLIENTHL7|CLI01020304|SERVHL7|PREPAGA^112233^IIN|20120201101155||ZQA^Z02^ZQA_Z02|00XX20120201101155|P|2.4|||ER|SU|ARG\r" <>
      "PRD|PS~4600^^HL70454||^^^B||||30123456789^CU\r" <>
      "PID|0||1234567890ABC^^^&112233&IIN^HC||unknown\r" <>
      "PR1|1||903401^^99DH\r" <>
      "AUT||112233||||||1|0\r" <>
      "PR1|2||904620^^99DH\r" <>
      "AUT||112233||||||1|0\r"
      reader = HL7.Reader.new(input_format: :wire, trim: true)
      {:ok, message} = HL7.Message.read(reader, msg)
      message
  end

  def testWriter() do
      message = %HL7.Segment.Default.AUT{
          plan_id: "1",
          plan_name: "simple",
          company_id: "1",
          company_name: "eZdorovya"
      }
      buffer = HL7.write([message], output_format: :text, trim: true)
      IO.puts buffer
  end

  @type segment_id :: Type.segment_id()
  @type sequence :: Type.sequence()
  @type composite_id :: Type.composite_id()
  @type field :: Type.field()
  @type item_type :: Type.item_type()
  @type value_type :: Type.value_type()
  @type value :: Type.value()
  @type repetition :: Type.repetition()
  @type read_option :: Reader.option()
  @type write_option :: Writer.option()
  @type read_ret ::
          {:ok, Message.t()}
          | {:incomplete, {(binary -> read_ret), rest :: binary}}
          | {:error, reason :: any}

  @doc """
  Reads a binary containing an HL7 message converting it to a list of segments.

  ## Arguments

  * `buffer`: a binary containing the HL7 message to be parsed (partial
    messages are allowed).

  * `options`: keyword list with the read options; these are:
    * `input_format`: the format the message in the `buffer` is in; it can be
      either `:wire` for the normal HL7 wire format with carriage-returns as
      segment terminators or `:text` for a format that replaces segment
      terminators with line feeds to easily output messages to a console or
      text file.
    * `segment_creator`: function that receives a segment ID and returns a
      tuple containing the module and the struct corresponding to the given
      segment ID. By default, `&HL7.Segment.new/1` is used.
    * `trim`: boolean that when set to `true` causes the fields to be
      shortened to their optimal layout, removing trailing empty items (see
      `HL7.Codec` for an explanation of this).

  ## Return values

  Returns the parsed message (i.e. list of segments) or raises an
  `HL7.ReadError` exception in case of error.

  ## Examples

  Given an HL7 message like the following bound to the `buffer` variable:

      "MSH|^~\\&|CLIENTHL7|CLI01020304|SERVHL7|PREPAGA^112233^IIN|20120201101155||ZQA^Z02^ZQA_Z02|00XX20120201101155|P|2.4|||ER|SU|ARG\r" <>
      "PRD|PS~4600^^HL70454||^^^B||||30123456789^CU\r" <>
      "PID|0||1234567890ABC^^^&112233&IIN^HC||unknown\r" <>
      "PR1|1||903401^^99DH\r" <>
      "AUT||112233||||||1|0\r" <>
      "PR1|2||904620^^99DH\r" <>
      "AUT||112233||||||1|0\r"

  You could read the message in the following way:

      iex> message = HL7.read!(buffer, input_format: :wire, trim: true)

  """
  @spec read!(buffer :: binary, [read_option()]) :: Message.t() | no_return
  def read!(buffer, options \\ []), do: Message.read!(Reader.new(options), buffer)

  @doc """
  Reads a binary containing an HL7 message converting it to a list of segments.

  ## Arguments

  * `buffer`: a binary containing the HL7 message to be parsed (partial
    messages are allowed).

  * `options`: keyword list with the read options; these are:
    * `input_format`: the format the message in the `buffer` is in; it can be
      either `:wire` for the normal HL7 wire format with carriage-returns as
      segment terminators or `:text` for a format that replaces segment
      terminators with line feeds to easily output messages to a console or
      text file.
    * `segment_creator`: function that receives a segment ID and returns a
      tuple containing the module and the struct corresponding to the given
      segment ID. By default, `&HL7.Segment.new/1` is used.
    * `trim`: boolean that when set to `true` causes the fields to be
      shortened to their optimal layout, removing trailing empty items (see
      `HL7.Codec` for an explanation of this).

  ## Return values

  * `{:ok, HL7.message}` if the buffer could be parsed successfully, then
    a message will be returned. This is actually a list of `HL7.segment`
    structs (check the [segment.ex](lib/ex_hl7/segment.ex) file to see the
    list of included segment definitions).

  * `{:incomplete, {(binary -> read_ret), rest :: binary}}` if the message
    in the string is not a complete HL7 message, then a function will be
    returned together with the part of the message that could not be parsed.
    You should acquire the remaining part of the message and concatenate it
    to the `rest` of the previous buffer. Finally, you have to call the
    function that was returned passing it the concatenated string.

  * `{:error, reason :: any}` if the contents of the buffer were malformed
    and could not be parsed correctly.

  ## Examples

  Given an HL7 message like the following bound to the `buffer` variable:

      "MSH|^~\\&|CLIENTHL7|CLI01020304|SERVHL7|PREPAGA^112233^IIN|20120201101155||ZQA^Z02^ZQA_Z02|00XX20120201101155|P|2.4|||ER|SU|ARG\\r" <>
      "PRD|PS~4600^^HL70454||^^^B||||30123456789^CU\\r" <>
      "PID|0||1234567890ABC^^^&112233&IIN^HC||unknown\\r" <>
      "PR1|1||903401^^99DH\\r" <>
      "AUT||112233||||||1|0\\r" <>
      "PR1|2||904620^^99DH\\r" <>
      "AUT||112233||||||1|0\\r"

  You could read the message in the following way:

      iex> {:ok, message} = HL7.read(buffer, input_format: :wire, trim: true)

  """
  @spec read(buffer :: binary, [read_option()]) :: read_ret()
  def read(buffer, options \\ []), do: Message.read(Reader.new(options), buffer)

  @doc """
  Writes a list of HL7 segments into an iolist.

  ## Arguments

  * `message`: a list of HL7 segments to be written into the string.

  * `options`: keyword list with the write options; these are:
    * `output_format`: the format the message will be written in; it can be
      either `:wire` for the normal HL7 wire format with carriage-returns as
      segment terminators or `:text` for a format that replaces segment
      terminators with line feeds to easily output messages to a console or
      text file. Defaults to `:wire`.
    * `separators`: a tuple containing the item separators to be used when
      generating the message as returned by `HL7.Codec.set_separators/1`.
      Defaults to `HL7.Codec.separators`.
    * `trim`: boolean that when set to `true` causes the fields to be
      shortened to their optimal layout, removing trailing empty items (see
      `HL7.Codec` for an explanation of this). Defaults to `true`.

  ## Return value

  iolist containing the message in the selected output format.

  ## Examples

  Given the `message` parsed in the `HL7.read/2` example you could do:

      iex> buffer = HL7.write(message, output_format: :text, trim: true)
      iex> IO.puts(buffer)

      MSH|^~\\&|CLIENTHL7|CLI01020304|SERVHL7|PREPAGA^112233^IIN|20120201101155||ZQA^Z02^ZQA_Z02|00XX20120201101155|P|2.4|||ER|SU|ARG
      PRD|PS~4600^^HL70454||^^^B||||30123456789^CU
      PID|0||1234567890ABC^^^&112233&IIN^HC||unknown
      PR1|1||903401^^99DH
      AUT||112233||||||1|0
      PR1|2||904620^^99DH
      AUT||112233||||||1|0

  """
  @spec write(Message.t(), [write_option()]) :: iodata
  def write(message, options \\ []), do: Message.write(Writer.new(options), message)

  @doc """
  Retrieve the segment ID from a segment.

  ## Return value

  If the argument is an `HL7.segment` the function returns a binary with the
  segment ID; otherwise it returns `nil`.

  ## Examples

      iex> aut = HL7.segment(message, "AUT")
      iex> "AUT" = HL7.segment_id(aut)

  """
  @spec segment_id(Segment.t()) :: segment_id()
  defdelegate segment_id(segment), to: Segment, as: :id

  @doc """
  Return the first repetition of a segment within a message.

  ## Return value

  If a segment with the passed `segment_id` can be found in the `message`
  then the function returns the segment; otherwise it returns `nil`.

  ## Examples

      iex> pr1 = HL7.segment(message, "PR1")
      iex> 1 = pr1.set_id

  """
  @spec segment(Message.t(), segment_id()) :: Segment.t() | nil
  defdelegate segment(message, segment_id), to: Message

  @doc """
  Return the nth repetition (0-based) of a segment within a message.

  ## Return value

  If the corresponding `repetition` of a segment with the passed `segment_id`
  is present in the `message` then the function returns the segment; otherwise
  it returns `nil`.

  ## Examples

      iex> pr1 = HL7.segment(message, "PR1", 0)
      iex> 1 = pr1.set_id
      iex> pr1 = HL7.segment(message, "PR1", 1)
      iex> 2 = pr1.set_id

  """
  @spec segment(Message.t(), segment_id(), repetition()) :: Segment.t() | nil
  defdelegate segment(message, segment_id, repetition), to: Message

  @doc """
  Return the first grouping of segments with the specified segment IDs.

  In HL7 messages sometimes some segments are immediately followed by other
  segments within the message. This function was created to help find those
  "grouped segments".

  For example, the `PR1` segment is sometimes followed by some other segments
  (e.g. `OBX`, `AUT`, etc.) to include observations and other related
  information for a practice. Note that there might be multiple segment
  groupings in a message.

  ## Return value

  A list of segments corresponding to the segment IDs that were passed. The
  list might not include all of the requested segments if they were not
  present in the message. The function will stop as soon as it finds a segment
  that does not belong to the passed sequence.

  ## Examples

      iex> [pr1, aut] = HL7.paired_segments(message, ["PR1", "AUT"])

  """
  @spec paired_segments(Message.t(), [segment_id()]) :: [Segment.t()]
  defdelegate paired_segments(message, segment_ids), to: Message

  @doc """
  Return the nth (0-based) grouping of segments with the specified segment IDs.

  In HL7 messages sometimes some segments are immediately followed by other
  segments within the message. This function was created to help find those
  "grouped segments".

  For example, the `PR1` segment is sometimes followed by some other segments
  (e.g. `OBX`, `AUT`, etc.) to include observations and other related
  information for a practice. Note that there might be multiple segment
  groupings in a message.

  ## Return value

  A list of segments corresponding to the segment IDs that were passed. The
  list might not include all of the requested segments if they were not
  present in the message. The function will stop as soon as it finds a segment
  that does not belong to the passed sequence.

  ## Examples

      iex> [pr1, aut] = HL7.paired_segments(message, ["PR1", "AUT"], 0)
      iex> [pr1, aut] = HL7.paired_segments(message, ["PR1", "AUT"], 1)
      iex> [] = HL7.paired_segments(message, ["PR1", "AUT"], 2)
      iex> [aut] = HL7.paired_segments(message, ["PR1", "OBX"], 1)

  """
  @spec paired_segments(Message.t(), [segment_id()], repetition()) :: [Segment.t()]
  defdelegate paired_segments(message, segment_ids, repetition), to: Message

  @doc """
  It skips over the first `repetition` groups of paired segment and invokes
  `fun` for each subsequent group of paired segments in the `message`. It
  passes the following arguments to `fun` on each call:

    - list of segments found that correspond to the group.
    - index of the group of segments in the `message` (0-based).
    - accumulator `acc` with the incremental results returned by `fun`.

  In HL7 messages sometimes some segments are immediately followed by other
  segments within the message. This function was created to easily process
  those "paired segments".

  For example, the `PR1` segment is sometimes followed by some other segments
  (e.g. `OBX`, `AUT`, etc.) to include observations and other related
  information for a procedure. Note that there might be multiple segment
  groupings in a message.

  ## Arguments

  * `message`: list of segments containing a decoded HL7 message.

  * `segment_ids`: list of segment IDs that define the group of segments to
  retrieve.

  * `repetition`: index of the group of segments to retrieve (0-based); it also
  corresponds to the number of groups to skip.

  * `acc`: term containing the initial value of the accumulator to be passed to
  the `fun` callback.

  * `fun`: callback function receiving a group of segments, the index of the
  group in the message and the accumulator.

  ## Return value

  The accumulator returned by `fun` in its last invocation.

  ## Examples

      iex> HL7.reduce_paired_segments(message, ["PR1", "AUT"], 0, [], fun segments, index, acc ->
        segment_ids = for segment <- segments, do: HL7.segment_id(segment)
        [{index, segment_ids} | acc]
      end

      [{0, ["PR1", "AUT"]}, {1, ["PR1", "AUT"]}]

  """
  @spec reduce_paired_segments(
          Message.t(),
          [segment_id()],
          repetition(),
          acc :: term,
          ([Segment.t()], repetition(), acc :: term -> acc :: term)
        ) :: acc :: term
  defdelegate reduce_paired_segments(message, segment_ids, repetition, acc, fun), to: Message

  @doc """
  Return the number of segments with a specified segment ID in an HL7 message.

  ## Examples

      iex> 2 = HL7.segment_count(message, "PR1")
      iex> 0 = HL7.segment_count(message, "OBX")

  """
  @spec segment_count(Message.t(), segment_id()) :: non_neg_integer
  defdelegate segment_count(message, segment_id), to: Message

  @doc """
  Deletes the first repetition of a segment in a message

  ## Examples

      iex> HL7.delete(message, "NTE")

  """
  @spec delete(Message.t(), segment_id()) :: Message.t()
  defdelegate delete(message, segment_id), to: Message

  @doc """
  Deletes the given repetition (0-based) of a segment in a message

  ## Examples

      iex> HL7.delete(message, "NTE", 0)

  """
  @spec delete(Message.t(), segment_id(), repetition()) :: Message.t()
  defdelegate delete(message, segment_id, repetition), to: Message

  @doc """
  Inserts a segment or group of segments before the first repetition of an
  existing segment in a message.

  ## Arguments

  * `message`: the `HL7.message` where the segment/s will be inserted.

  * `segment_id`: the segment ID of a segment that should be present in the
    `message`.

  * `segment`: the segment or list of segments that will be inserted

  ## Return values

  If a segment with the `segment_id` was present, the function will return a
  new message with the inserted segments. If not, it will return the original
  message

  ## Examples

      iex> alias HL7.Segment.MSA
      iex> ack = %MSA{ack_code: "AA", message_control_id: "1234"}
      iex> HL7.insert_before(message, "ERR", msa)

  """
  @spec insert_before(Message.t(), segment_id(), Segment.t() | [Segment.t()]) :: Message.t()
  defdelegate insert_before(message, segment_id, segment), to: Message

  @doc """
  Inserts a segment or group of segments before the given repetition of an
  existing segment in a message.

  ## Arguments

  * `message`: the `HL7.message` where the segment/s will be inserted.

  * `segment_id`: the segment ID of a segment that should be present in the
    `message`.

  * `repetition`: the repetition (0-based) of the `segment_id` in the `message`.

  * `segment`: the segment or list of segments that will be inserted

  ## Return values

  If a segment with the `segment_id` was present with the given `repetition`,
  the function will return a new message with the inserted segments. If not,
  it will return the original message

  ## Examples

      iex> alias HL7.Segment.MSA
      iex> ack = %MSA{ack_code: "AA", message_control_id: "1234"}
      iex> HL7.insert_before(message, "ERR", 0, msa)

  """
  @spec insert_before(Message.t(), segment_id(), repetition(), Segment.t() | [Segment.t()]) ::
          Message.t()
  defdelegate insert_before(message, segment_id, repetition, segment), to: Message

  @doc """
  Inserts a segment or group of segments after the first repetition of an
  existing segment in a message.

  ## Arguments

  * `message`: the `HL7.message` where the segment/s will be inserted.

  * `segment_id`: the segment ID of a segment that should be present in the
    `message`.

  * `segment`: the segment or list of segments that will be inserted

  ## Return values

  If a segment with the `segment_id` was present, the function will return a
  new message with the inserted segments. If not, it will return the original
  message

  ## Examples

      iex> alias HL7.Segment.MSA
      iex> ack = %MSA{ack_code: "AA", message_control_id: "1234"}
      iex> HL7.insert_after(message, "MSH", msa)

  """
  @spec insert_after(Message.t(), segment_id(), Segment.t() | [Segment.t()]) :: Message.t()
  defdelegate insert_after(message, segment_id, segment), to: Message

  @doc """
  Inserts a segment or group of segments after the given repetition of an
  existing segment in a message.

  ## Arguments

  * `message`: the `HL7.message` where the segment/s will be inserted.

  * `segment_id`: the segment ID of a segment that should be present in the
    `message`.

  * `repetition`: the repetition (0-based) of the `segment_id` in the `message`.

  * `segment`: the segment or list of segments that will be inserted

  ## Return values

  If a segment with the `segment_id` was present with the given `repetition`,
  the function will return a new message with the inserted segments. If not,
  it will return the original message

  ## Examples

      iex> alias HL7.Segment.MSA
      iex> ack = %MSA{ack_code: "AA", message_control_id: "1234"}
      iex> HL7.insert_after(message, "MSH", 0, msa)

  """
  @spec insert_after(Message.t(), segment_id(), repetition(), Segment.t() | [Segment.t()]) :: Message.t()
  defdelegate insert_after(message, segment_id, repetition, segment), to: Message

  @doc """
  Replaces the first repetition of an existing segment in a message.

  ## Arguments

  * `message`: the `HL7.message` where the segment/s will be inserted.

  * `segment_id`: the segment ID of a segment that should be present in the
    `message`.

  * `segment`: the segment or list of segments that will replace the existing
    one.

  ## Return values

  If a segment with the `segment_id` was present, the function will return a
  new message with the replaced segments. If not, it will return the original
  message

  ## Examples

      iex> alias HL7.Segment.MSA
      iex> ack = %MSA{ack_code: "AA", message_control_id: "1234"}
      iex> HL7.replace(message, "MSA", msa)

  """
  @spec replace(Message.t(), segment_id(), Segment.t()) :: Message.t()
  defdelegate replace(message, segment_id, segment), to: Message

  @doc """
  Replaces the given repetition of an existing segment in a message.

  ## Arguments

  * `message`: the `HL7.message` where the segment/s will be inserted.

  * `segment_id`: the segment ID of a segment that should be present in the
    `message`.

  * `repetition`: the repetition (0-based) of the `segment_id` in the `message`.

  * `segment`: the segment or list of segments that will replace the existing
    one.

  ## Return values

  If a segment with the `segment_id` was present with the given `repetition`,
  the function will return a new message with the replaced segments. If not,
  it will return the original message.

  ## Examples

      iex> alias HL7.Segment.MSA
      iex> ack = %MSA{ack_code: "AA", message_control_id: "1234"}
      iex> HL7.replace(message, "MSA", 0, msa)

  """
  @spec replace(Message.t(), segment_id(), repetition(), Segment.t()) :: Message.t()
  defdelegate replace(message, segment_id, repetition, segment), to: Message

  @doc """
  Escape a string that may contain separators using the HL7 escaping rules.

  ## Arguments

  * `value`: a string to escape; it may or may not contain separator
    characters.

  * `options`: keyword list with the escape options; these are:
    * `separators`: a tuple containing the item separators to be used when
      generating the message as returned by `HL7.Codec.set_separators/1`.
      Defaults to `HL7.Codec.separators`.
    * `escape_char`: character to be used as escape delimiter. Defaults to `?\\\\ `
      (backlash).

  ## Examples

      iex> "ABCDEF" = HL7.escape("ABCDEF")
      iex> "ABC\\\\F\\\\DEF\\\\F\\\\GHI" = HL7.escape("ABC|DEF|GHI", separators: HL7.Codec.separators())

  """
  @spec escape(binary, options :: Keyword.t()) :: binary
  def escape(value, options \\ []) do
    separators = Keyword.get(options, :separators, Codec.separators())
    escape_char = Keyword.get(options, :escape_char, ?\\)
    Codec.escape(value, separators, escape_char)
  end

  @doc """
  Convert an escaped string into its original value.

  ## Arguments

  * `value`: a string to unescape; it may or may not contain escaped characters.

  * `options`: keyword list with the escape options; these are:
    * `separators`: a tuple containing the item separators to be used when
      generating the message as returned by `HL7.Codec.set_separators/1`.
      Defaults to `HL7.Codec.separators`.
    * `escape_char`: character to be used as escape delimiter. Defaults to `?\\\\ `
      (backlash).

  ## Examples

      iex> "ABCDEF" = HL7.unescape("ABCDEF")
      iex> "ABC|DEF|GHI" = HL7.unescape("ABC\\\\F\\\\DEF\\\\F\\\\GHI", escape_char: ?\\)

  """
  @spec unescape(binary, options :: Keyword.t()) :: binary
  def unescape(value, options \\ []) do
    separators = Keyword.get(options, :separators, Codec.separators())
    escape_char = Keyword.get(options, :escape_char, ?\\)
    Codec.unescape(value, separators, escape_char)
  end

  @vertical_tab 0x0b
  @file_separator 0x1c
  @carriage_return 0x0d

  @doc """
  Add MLLP framing to an already encoded HL7 message.

  An MLLP-framed message carries a one byte vertical tab (0x0b) control code
  as header and a two byte trailer consisting of a file separator (0x1c) and
  a carriage return (0x0d) control code.

  ## Arguments

  * `buffer`: binary or iolist containing an encoded HL7 message as returned
              by `HL7.write/2`.
  """
  @spec to_mllp(buffer :: iodata) :: iolist
  def to_mllp(buffer) when is_binary(buffer) or is_list(buffer) do
    [@vertical_tab, buffer, @file_separator, @carriage_return]
  end

  @doc """
  Remove MLLP framing from an already encoded HL7 message.

  An MLLP-framed message carries a one byte vertical tab (0x0b) control code
  as header and a two byte trailer consisting of a file separator (0x1c) and
  a carriage return (0x0d) control code.

  ## Arguments

  * `buffer`: binary or iolist containing an MLLP-framed HL7 message as
    returned by `HL7.to_mllp/1`.

  ## Return value

  Returns the encoded message with the MLLP framing removed.

  """
  @spec from_mllp(buffer :: iodata) ::
          {:ok, msg_buffer :: iodata} | :incomplete | {:error, reason :: term}
  def from_mllp([@vertical_tab, msg_buffer, @file_separator, @carriage_return]) do
    {:ok, msg_buffer}
  end

  def from_mllp([@vertical_tab | tail]) do
    case Enum.reverse(tail) do
      [@carriage_return, @file_separator | msg_iolist] ->
        {:ok, Enum.reverse(msg_iolist)}

      _ ->
        :incomplete
    end
  end

  def from_mllp(buffer) when is_binary(buffer) do
    msg_len = byte_size(buffer) - 3

    case buffer do
      <<@vertical_tab, msg_buffer::binary-size(msg_len), @file_separator, @carriage_return>>
      when msg_len > 0 ->
        {:ok, msg_buffer}

      <<@vertical_tab, _tail::binary>> ->
        :incomplete

      _ ->
        {:error, :bad_mllp_framing}
    end
  end

  @doc """
  Remove MLLP framing from an already encoded HL7 message.

  An MLLP-framed message carries a one byte vertical tab (0x0b) control code
  as header and a two byte trailer consisting of a file separator (0x1c) and
  a carriage return (0x0d) control code.

  ## Arguments

  * `buffer`: binary or iolist containing an MLLP-framed HL7 message as
     returned by `HL7.to_mllp/1`.

  ## Return value

  Returns the encoded message with the MLLP framing removed or raises an
  `HL7.ReadError` exception in case of error.

  """
  @spec from_mllp!(buffer :: iodata) :: msg_buffer :: iodata | no_return
  def from_mllp!(buffer) do
    case from_mllp(buffer) do
      {:ok, msg_buffer} -> msg_buffer
      :incomplete -> raise HL7.ReadError, :incomplete
      {:error, reason} -> raise HL7.ReadError, reason
    end
  end
end
