defmodule AwsApi.Test do
  def request(stubbed_test_response) do
    stubbed_test_response
  end

  def list_objects(bucket) do
    {:ok, %{
      body: %{
        common_prefixes: [],
        contents: [
          %{
            e_tag: "\"0847ca90983251227e0a0d48d548906c\"",
            key: "abc123-face.jpg",
            last_modified: "2019-01-30T20:54:40.000Z",
            owner: %{
              display_name: "",
              id: "eb87b1c42a856d6fe9074294cf8475a71fbcd009f4b461fe7ee75f0b13db410b"
            },
            size: "47008",
            storage_class: "STANDARD"
          }
        ],
        is_truncated: "false",
        marker: "",
        max_keys: "1000",
        name: bucket,
        next_marker: "",
        prefix: ""
      },
      headers: [
        {"x-amz-id-2",
          "hSs6+GVcrg2tRGcwUMIpGzvwOfdQ47G64qKeMlj9AsOKNqXfimasXy7GXoZ/njjZCmmxxfkzlNY="},
        {"x-amz-request-id", "8EB2A39F2FB6783E"},
        {"Date", "Wed, 30 Jan 2019 21:45:12 GMT"},
        {"x-amz-bucket-region", "eu-west-2"},
        {"Content-Type", "application/xml"},
        {"Transfer-Encoding", "chunked"},
        {"Server", "AmazonS3"}
      ],
      status_code: 200
    }}
  end

  def get_object(_bucket, _object) do
    {:ok, %{
        body: <<255, 255, 255>>, # truncated for test env
        headers: [
          {"x-amz-id-2",
            "vGoEv9hvAXwV22EQ1DtjRpxbEdnwZdu99VPD+zMHkcbPpsqegipYbjYl3vHQKZh6748ZGlr/wDs="},
          {"x-amz-request-id", "0016B89BD9F2375C"},
          {"Date", "Wed, 30 Jan 2019 22:41:19 GMT"},
          {"Last-Modified", "Wed, 30 Jan 2019 20:54:40 GMT"},
          {"ETag", "\"0847ca90983251227e0a0d48d548906c\""},
          {"Accept-Ranges", "bytes"},
          {"Content-Type", "image/jpeg"},
          {"Content-Length", "47008"},
          {"Server", "AmazonS3"}
        ],
        status_code: 200
    }}
  end

  def put_object(_bucket, _object, _body) do
    {:ok, %{
        body: "",
        headers: [
          {"x-amz-id-2",
            "H7gtnFKdIF0b2yvnCGhl9r/+wL2wplG3rAUOhJCigLLvOH9UIF/PGjXoliCSPH0wMan25h6uqdc="},
          {"x-amz-request-id", "7D6366BAE6838955"},
          {"Date", "Wed, 30 Jan 2019 23:17:06 GMT"},
          {"ETag", "\"0847ca90983251227e0a0d48d548906c\""},
          {"Content-Length", "0"},
          {"Server", "AmazonS3"}
        ],
        status_code: 200
    }}
  end
end
