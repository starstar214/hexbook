:currency_exchange: **Elasticsearch-高扩展的分布式全文搜索引擎**



---

#### 1.Elasticsearch 概述

在信息社会，数据可以被划分为 3 大类：

1. 结构化数据：结构化的数据是可以使用关系型数据库表示和存储的数据，表现为二维形式的数据，也就是传统 DBMS 数据库存储的信息。

2. 半结构化数据：半结构化数据是结构化数据的一种形式，它包含相关标记，用来分隔语义元素以及对记录和字段进行分层，因此它也被称为自描述的结构。常见的半结构数据有 XML 和 JSON 等。

3. 非结构化数据：非结构化数据的数据结构不规则或不完整，也没有预定义数据模型，常见的如各种文本、图片、视频/音频等。

传统的 DBMS 数据库对于非结构化数据的存储和查询的能力非常有限，而 Elasticsearch 的出现解决了这一问题，它适用于包括文本、数字、地理空间、结构化和非结构化数据等在内的所有类型的数据，并对它们进行搜索和分析。



Lucene 与 Elasticsearch、Solr：

Lucene 是 Apache 软件基金会 Jakarta 项目组的一个子项目，提供了一个简单却强大的应用程式接口，能够做全文索引和搜寻。但 Lucene 只是一个提供全文搜索功能类库的核心工具包，而真正使用它还需要一个完善的服务框架搭建起来进行应用。
目前市面上流行的搜索引擎软件，主流的就两款：Elasticsearch 和 Solr，这两款都是基于 Lucene 搭建的，可以独立部署启动的搜索引擎服务软件。



Elasticsearch 和 Solr 对比：

1. 相对于 Solr 来说，Elasticsearch 更加轻量级且易于安装。

   例如：安装 Solr 时还需要安装 Zookeeper 进行分布式管理，而 Elasticsearch 自身带有分布式协调管理功能。

2. Solr 支持更多格式的数据，如 JSON、XML、CSV，而 Elasticsearch 仅支持 JSON 类型的数据。

3. Solr 的查询性能更好但索引更新速度不如 Elasticsearch（所以 Elasticsearch 对实时搜索功能支持更好）。

4. Elasticsearch 相比于 Solr 而言暴露了更多的监控和指标，更好地帮助我们处理分析查询。

5. Elasticsearch 的可伸缩性和分布式环境的支持更加的优于 Solr。

> :eagle: 所以，Solr 更加适合于传统的搜索引擎（如：电子图书馆，离线搜索应用等），而 Elasticsearch 更加适合于分布式的实时搜索的应用（如：FaceBook，微博）。



---

#### 2.Elasticsearch 安装

Elasticsearch 官网：https://www.elastic.co/cn/elasticsearch/



在安装 Elasticsearch 之前，需要先安装 java 环境。

~~~shell
[root@localhost ~]# dnf install java-1.8.0-openjdk-devel.x86_64
~~~

在官网上提供了使用 dnf 命令在线安装 Elasticsearch 的方法：

1. 在 `/etc/yum.repos.d/` 路径下新建 `elasticsearch.repo` 文件，文件内容如下：

   ~~~properties
   [elasticsearch]
   name=Elasticsearch repository for 7.x packages
   baseurl=https://artifacts.elastic.co/packages/7.x/yum
   gpgcheck=1
   gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
   enabled=0
   autorefresh=1
   type=rpm-md
   ~~~

   这一步及手动的添加了 Elasticsearch 的 yum 源。

2. 使用 dnf 命令进行安装：

   ~~~shell
   [root@localhost ~]# dnf install --enablerepo=elasticsearch elasticsearch
   ~~~

   使用 `systemctl start elasticsearch.service` 即可启动 Elasticsearch 服务。



在启动 Elasticsearch 后，Elasticsearch 将会暴露 9200 端口为浏览器的 RESTful 接口访问端口。

使用 curl 命令即可与 Elasticsearch 进行通信：

~~~shell
[root@localhost elasticsearch]# curl -XGET localhost:9200
{
  "name" : "localhost.localdomain",
  "cluster_name" : "elasticsearch",
  "cluster_uuid" : "trH5F2nvQa2uXy9QjIF7TQ",
  "version" : {
    "number" : "7.14.0",
    "build_flavor" : "default",
    "build_type" : "rpm",
    "build_hash" : "dd5a0a2acaa2045ff9624f3729fc8a6f40835aa1",
    "build_date" : "2021-07-29T20:49:32.864135063Z",
    "build_snapshot" : false,
    "lucene_version" : "8.9.0",
    "minimum_wire_compatibility_version" : "6.8.0",
    "minimum_index_compatibility_version" : "6.0.0-beta1"
  },
  "tagline" : "You Know, for Search"
}
~~~

配置 Elasticsearch 的远程访问，配置文件地址：`/etc/elasticsearch/elasticsearch.yml`

修改内容：

~~~yml
node.name: node-1 # 当前节点名称
network.host: 0.0.0.0  # 允许任何 IP 地址进行访问
cluster.initial_master_nodes: ["node-1"]  # Elasticsearch 默认节点名
~~~

然后就可以从其他 IP 地址对 Elasticsearch 进行访问。



---

#### 3.Elasticsearch 索引

Elasticsearch 的数据格式：

1. 索引（Index）：类比于 MySQL 中的数据库对象。
2. 类型（Type）：类比于 MySQL 中的表，在 7.x 中此类型已被删除。
3. 文档（Documents）：类比于 MySQL 中的行数据，也就是一条数据记录。
4. 字段（Field）：类比于 MySQL 中的列。



Elasticsearch 索引操作：

1. 创建索引 Index（类似于创建 MySQL 数据库）

   向 Elasticsearch 发送 PUT 请求：http://192.168.253.132:9200/shopping，得到响应：

   ~~~json
   {
       "acknowledged": true,
       "shards_acknowledged": true,
       "index": "shopping"
   }
   ~~~

2. 获取索引信息：将请求改为 GET 发送即可。

3. 获取 Elasticsearch 中所有 Index 信息：http://192.168.253.132:9200/_cat/indices?v=true（GET）

   ~~~shell
   health status index            uuid                   pri rep docs.count docs.deleted store.size pri.store.size
   green  open   .geoip_databases KFILY5sQS3Sc1LXzjDLbVw   1   0         41           37     40.1mb         40.1mb
   yellow open   shopping         4Fi0ScYKSHetH7HcNbIgtQ   1   1          0            0       208b           208b
   ~~~

   不加参数 v=true 时，只展示简略信息。信息中各个参数含义：

   | 参数名         | 含义                                                         |
   | -------------- | ------------------------------------------------------------ |
   | health         | 当前服务器健康状态：green（集群完整）、yellow（单点正常，集群不完整）、red（单点不正常） |
   | status         | 索引打开、关闭状态                                           |
   | index          | 索引名                                                       |
   | uuid           | 索引编号 uuid                                                |
   | pri            | 主分片数量                                                   |
   | rep            | 副本数量                                                     |
   | docs.count     | 可用文档数量                                                 |
   | docs.deleted   | 文档删除个数（逻辑删除）                                     |
   | store.size     | 主分片和副分片整体占用空间大小                               |
   | pri.store.size | 主分片占用空间大小                                           |

4. 删除索引：将请求改为 DELETE 发送即可。



---

#### 4.Elasticsearch 文档

Elasticsearch 中常用的 HTTP 方法：

| HTTP 方法 | 描述                                                         |
| --------- | ------------------------------------------------------------ |
| GET       | 请求指定的资源信息，返回实体主体                             |
| POST      | 向指定资源提交数据处理请求（POST 请求可能会导致新的资源的建立或已有资源的修改） |
| PUT       | 从客户端向服务器传送取代指定资源的信息（全量修改）           |
| DELETE    | 请求服务器删除指定的资源                                     |

> :basketball_man: 幂等性：就是用户对于同一操作发起的一次请求或者多次请求的结果是一致的，不会因为多次点击而产生了副作用。
>
> 在 Elasticsearch 中，除 POST 请求之外其他请求都要求是幂等性的。



添加数据：

1. 不指定 ID 添加数据：向 Elasticsearch 发送 POST 请求，请求路径为

   ~~~http
   http://192.168.253.132:9200/xxx/_doc
   ~~~

   其中 xxx 为索引名，需要添加的文档数据放在 Request Body 中进行发送（发送的数据应该为 JSON 数据），返回的数据为：

   ~~~json
   {
       "_index": "shopping",
       "_type": "_doc",
       "_id": "5uWVK3sBFN0MjPUocWeh",
       "_version": 1,
       "result": "created",
       "_shards": {
           "total": 2,
           "successful": 1,
           "failed": 0
       },
       "_seq_no": 0,
       "_primary_term": 1
   }
   ~~~

   由于没有手动指定唯一标识，Elasticsearch 将自动生成 _id。

2. 指定 ID 添加数据：向 Elasticsearch 发送 POST/PUT 请求，请求路径为

   ~~~http
   http://192.168.253.132:9200/xxx/_doc/1
   ~~~

   由于在手动添加了 ID 后，无论发送了多少次请求，产生的结果都是一样的，满足了请求的幂等性，所以该请求也可以使用 PUT 请求进行发送。

   > :chart_with_downwards_trend: 指定 ID 发送请求时，如果存在该 ID 的数据，就是在原基础上进行更新（会更改 version 值）

   指定 id 进行文档添加/更新的 url 也可以是：

   ~~~http
   http://192.168.253.132:9200/shopping/_create/2
   ~~~

   注意：使用 `_create` 添加/更新文档时必须指定 ID。



修改文档数据：

1. 全量修改：即 POST/PUT 请求`http://192.168.253.132:9200/xxx/_doc/1`（不存在数据时创建，存在数据时全量更新）

2. 部分修改：POST 请求`http://192.168.253.132:9200/xxx/_update/1`，发送的 Request Body 如下

   ~~~json
   {
       "doc": {
           "price": 3333
       }
   }
   ~~~

   即值进行 price 的修改。



删除文档数据：DELEE 请求`http://192.168.253.132:9200/xxx/_doc/1`



查询文档数据：

1. 按照 ID 查找文档数据：

   ~~~http
   http://192.168.253.132:9200/shopping/_doc/1
   ~~~

2. 查找索引下的所有文档数据：

   ~~~http
   http://192.168.253.132:9200/shopping/_search
   ~~~

条件查询：

1. 按照指定条件进行查询：

   ~~~http
   http://192.168.253.132:9200/shopping/_search?q=price:3999
   ~~~

   或者将查询条件放入 Body 中：`http://192.168.253.132:9200/shopping/_search`，请求体为

   ~~~json
   {
       "query": {
           "match": {
               "price": 3333
           }
       }
   }
   ~~~

2. 分页查询：`http://192.168.253.132:9200/shopping/_search`，请求体为

   ~~~json
   {
       "query": {
           "match_all": {}
       },
       "from": 0,
       "size": 2
   }
   ~~~

3. 查询时指定显示的字段：

   ~~~json
   {
       "query": {
           "match_all": {}
       },
       "_source": ["price","title"]
   }
   ~~~

   也可以使用排除和包含的方式进行指定：

   ~~~json
   {
       "query": {
           "match_all": {}
       },
       "_source": {
           "include": [
               "images"
           ],
           "exclude": [
               "price"
           ]
       }
   }
   ~~~

4. 按照字段进行排序：

   ~~~json
   {
       "query": {
           "match_all": {}
       },
       "sort": {
           "price": {
               "order": "asc"
           }
       }
   }
   ~~~

5. 多条件查询：

   ~~~json
   {
       "query": {
           "bool": {
               "must": [
                   {
                       "match": {
                           "category": "小米"
                       }
                   },
                   {
                       "match": {
                           "title": "小米手机"
                       }
                   }
               ],
               "filter": {
                   "range": {
                       "price": {
                           "gt": 2999,
                           "lte": 3999
                       }
                   }
               }
           }
       }
   }
   ~~~

   - must 指全部满足（多个条件同时成立），如果需要或的逻辑则使用 should。
   - gt 为大于，lt 为小于，gte 为大于等于，lte 为小于等于。

6. 全文检索，使用 match 进行匹配时默认进行的是模糊分词匹配：

   ~~~json
   {
       "query": {
           "match": {
               "title": "小青"
           }
       }
   }
   ~~~

   输入 "小青"，仍能匹配到 "小米手机"，因为 Elasticsearch 底层采用分词进行模糊匹配，如果需要精确匹配，则使用：

   ~~~json
   {
       "query": {
           "match_phrase": {
               "title": "小青"
           }
       }
   }
   ~~~

7. 对查询结果高亮处理：

   ~~~json
   {
       "query": {
           "match": {
               "title": "小米"
           }
       },
       "highlight": {
           "fields": {
               "title": {}
           }
       }
   }
   ~~~

8. 聚合查询：

   ~~~json
   {
       "aggs": { // 分组查询
           "price_group": { // 组名，随意取
               "terms": {
                   "field": "price"  // 分组字段
               }
           }
       },
       "size": 0  // 不显示原始数据
   }
   ~~~

   平均值查询：

   ~~~json
   {
       "aggs": {
           "price_avg": {
               "avg": {
                   "field": "price"
               }
           }
       },
       "size": 0
   }
   ~~~

   

---

#### 5.Elasticsearch 映射

Elasticsearch 中的映射类似于 MySQL 中的表结构，创建数据库表需要设置字段名称，类型，长度，约束等；索引库也一样，需要知道这个类型下有哪些字段，每个字段有哪些约束信息，这就叫做映射（mapping）。



创建映射：POST 请求`http://192.168.253.132:9200/user/_mapping`

~~~json
{
    "properties": {
        "name": {
            "type": "text", // 文本类型
            "index": true   // 可以被索引
        },
        "gender": {
            "type": "keyword", // 关键字，不能被分词索引
            "index": true
        },
        "phoneNumber": {
            "type": "text",
            "index": false
        }
    }
}
~~~



> :yum: 映射不会影响向 Index 中添加数据，只会限制数据的查询。



映射的字段说明：

1. type：类型，常见的类型如下

   1. 字符串：text（可分词）、keyword（不可分词）
   2. 数值类型：可以分两类
      1. 基本数据类型：long、integer、short、byte、double、float、half_float
      2. 浮点数的高精度类型：scaled_float
   3. 日期类型：date
   4. 数组类型：array
   5. 对象：object

2. index：是否允许被索引，默认为 true。

3. store：是否将数据进行独立存储，默认为 false。

   > 原始的文本会存储在 \_source 里面，默认情况下其他提取出来的字段都不是独立存储的，是从 \_source 里面提取出来的。
   >
   > 我们也可以独立的存储某个字段，只要设置 "store": true 即可，获取独立存储的字段要比从_source中解析快得多，但是也会占用更多的空间，所以要根据实际业务需求来设置。

4. analyzer：分词器，指定使用的分词器。



---

#### 6.Java 操作 Elasticsearch 

搭建 Maven 项目，引入依赖：

~~~xml
<dependency>
    <groupId>org.elasticsearch</groupId>
    <artifactId>elasticsearch</artifactId>
    <version>7.9.3</version>
</dependency>
<dependency>
    <groupId>org.elasticsearch.client</groupId>
    <artifactId>elasticsearch-rest-high-level-client</artifactId>
    <version>7.9.3</version>
</dependency>
~~~



使用客户端连接 Elasticsearch：

~~~java
RestHighLevelClient client = new RestHighLevelClient(RestClient.builder(new HttpHost("192.168.253.132", 9200)));
// 执行操作
client.close();
~~~

创建索引：

~~~java
IndicesClient indicesClient = client.indices();
CreateIndexRequest indexRequest = new CreateIndexRequest("cars");
CreateIndexResponse response = indicesClient.create(indexRequest, RequestOptions.DEFAULT);
System.out.println("响应状态：" + response.isAcknowledged());
~~~

查询索引：

~~~java
IndicesClient indicesClient = client.indices();
GetIndexRequest getIndexRequest = new GetIndexRequest("cars");
GetIndexResponse getIndexResponse = indicesClient.get(getIndexRequest, RequestOptions.DEFAULT);
System.out.println(getIndexResponse.getAliases());
System.out.println(getIndexResponse.getMappings());
System.out.println(getIndexResponse.getSettings());
~~~

删除索引（DeleteIndexRequest）的操作同理。



创建文档数据：

~~~java
RestHighLevelClient client = new RestHighLevelClient(RestClient.builder(new HttpHost("192.168.253.132", 9200)));
IndexRequest indexRequest = new IndexRequest("cars").id("0001");
Car car = new Car().setTitle("全新梅赛德斯-迈巴赫S级轿车").setBrand("梅赛德斯奔驰").setOrigin("德国").setPrice(BigDecimal.valueOf(420000.0));
String jsonStr = JSONUtil.toJsonStr(car);
indexRequest.source(jsonStr, XContentType.JSON);
IndexResponse response = client.index(indexRequest, RequestOptions.DEFAULT);
System.out.println("执行结果：" + response.getResult());
client.close();
~~~

更新文档数据：

~~~java
RestHighLevelClient client = new RestHighLevelClient(RestClient.builder(new HttpHost("192.168.253.132", 9200)));
UpdateRequest updateRequest = new UpdateRequest("cars", "0001");
updateRequest.doc(XContentType.JSON, "price", BigDecimal.valueOf(430000.5));
UpdateResponse response = client.update(updateRequest, RequestOptions.DEFAULT);
System.out.println(response.getResult());
client.close();
~~~

按照 ID 查询（GetRequest）与按照 ID 删除（DeleteRequest）操作同理。



批量插入数据：

~~~java
RestHighLevelClient client = new RestHighLevelClient(RestClient.builder(new HttpHost("192.168.253.132", 9200)));
BulkRequest request = new BulkRequest();
Car car1 = new Car().setTitle("创新纯电动BMW iX3").setBrand("宝马").setOrigin("德国").setPrice(BigDecimal.valueOf(399900.0));
Car car2 = new Car().setTitle("AVENTADOR SVJ").setBrand("兰博基尼").setOrigin("意大利").setPrice(BigDecimal.valueOf(1200000.0));
request.add(new IndexRequest("cars").id("0002").source(JSONUtil.toJsonStr(car1), XContentType.JSON));
request.add(new IndexRequest("cars").id("0003").source(JSONUtil.toJsonStr(car2), XContentType.JSON));
BulkResponse response = client.bulk(request, RequestOptions.DEFAULT);
System.out.println(response.getTook());
client.close();
~~~

同理，批量删除时也使用 BulkRequest，在 request 中加入多个 DeleteRequest 进行删除。



---

#### 7.Elasticsearch 高级查询

全量查询：

~~~java
RestHighLevelClient client = new RestHighLevelClient(RestClient.builder(new HttpHost("192.168.253.132", 9200)));
SearchRequest searchRequest = new SearchRequest("cars");
searchRequest.source(new SearchSourceBuilder().query(QueryBuilders.matchAllQuery()));
SearchResponse search = client.search(searchRequest, RequestOptions.DEFAULT);
SearchHits hits = search.getHits();
for (SearchHit hit : hits) {
    System.out.println(hit.getSourceAsString());
}
client.close();
~~~



条件查询：

~~~java
RestHighLevelClient client = new RestHighLevelClient(RestClient.builder(new HttpHost("192.168.253.132", 9200)));
SearchRequest searchRequest = new SearchRequest("cars");
searchRequest.source(new SearchSourceBuilder().query(QueryBuilders.termQuery("origin.keyword", "德国")));
SearchResponse response = client.search(searchRequest, RequestOptions.DEFAULT);
// ...
client.close();
~~~

> :bust_in_silhouette: 因为 Elastic 分词器会将字段值进行分词，输入全量字段进行匹配时找不到对应的分词，所以 termQuery 的写法是：
>
> 使用`QueryBuilders.termQuery("origin.keyword", "德国")`进行精确匹配或使用`QueryBuilders.termQuery("origin", "德")`进行模糊搜索.



分页查询、排序、过滤字段：

~~~java
RestHighLevelClient client = new RestHighLevelClient(RestClient.builder(new HttpHost("192.168.253.132", 9200)));
SearchRequest searchRequest = new SearchRequest("cars");
SearchSourceBuilder builder = new SearchSourceBuilder().query(QueryBuilders.matchAllQuery());
// 分页参数
builder.from(0);
builder.size(3);
// 排序查询
builder.sort("price", SortOrder.DESC);
// 过滤字段 include title，exclude brand
builder.fetchSource(new String[]{"title"}, new String[]{"brand"});
searchRequest.source(builder);
SearchResponse response = client.search(searchRequest, RequestOptions.DEFAULT);
// ...
client.close();
~~~

组合条件查询、模糊查询、高亮查询：

~~~java
RestHighLevelClient client = new RestHighLevelClient(RestClient.builder(new HttpHost("192.168.253.132", 9200)));
SearchSourceBuilder searchSourceBuilder = new SearchSourceBuilder();
BoolQueryBuilder boolQueryBuilder = QueryBuilders.boolQuery();
boolQueryBuilder.must(QueryBuilders.matchQuery("origin.keyword", "德国"));
// 模糊查询，Fuzziness.TWO 指匹配与关键字两个字符查以内的目标
boolQueryBuilder.must(QueryBuilders.fuzzyQuery("title.keyword", "奥迪A").fuzziness(Fuzziness.TWO));
// 范围匹配
boolQueryBuilder.must(QueryBuilders.rangeQuery("price").from(BigDecimal.valueOf(300000.0)).to(BigDecimal.valueOf(1000000.0)));
searchSourceBuilder.query(boolQueryBuilder);
// 高亮查询
HighlightBuilder highlighter = new HighlightBuilder();
highlighter.preTags("<front color='red'>");
highlighter.postTags("</front>");
highlighter.field("origin.keyword");
searchSourceBuilder.highlighter(highlighter);
SearchRequest request = new SearchRequest("cars");
request.source(searchSourceBuilder);
SearchResponse response = client.search(request, RequestOptions.DEFAULT);
SearchHits hits = response.getHits();
for (SearchHit hit : hits) {
    System.out.println(hit.getHighlightFields());
    System.out.println(hit.getSourceAsString());
}
client.close();
~~~

最大值查询：

~~~java
RestHighLevelClient client = new RestHighLevelClient(RestClient.builder(new HttpHost("192.168.253.132", 9200)));
SearchSourceBuilder searchSourceBuilder = new SearchSourceBuilder();
AggregationBuilder aggregationBuilder = AggregationBuilders.max("maxPrice").field("price");
searchSourceBuilder.aggregation(aggregationBuilder);
SearchRequest request = new SearchRequest("cars");
request.source(searchSourceBuilder);
SearchResponse response = client.search(request, RequestOptions.DEFAULT);
System.out.println("最大值：" + ((ParsedMax) response.getAggregations().get("maxPrice")).getValue());
client.close();
~~~

分组查询：

~~~java
RestHighLevelClient client = new RestHighLevelClient(RestClient.builder(new HttpHost("192.168.253.132", 9200)));
SearchSourceBuilder searchSourceBuilder = new SearchSourceBuilder();
AggregationBuilder aggregationBuilder = AggregationBuilders.terms("originGroup").field("origin.keyword");
searchSourceBuilder.aggregation(aggregationBuilder);
SearchRequest request = new SearchRequest("cars");
request.source(searchSourceBuilder);
SearchResponse response = client.search(request, RequestOptions.DEFAULT);
ParsedStringTerms terms = response.getAggregations().get("originGroup");
for (Terms.Bucket bucket : terms.getBuckets()) {
    System.out.println(bucket.getKeyAsString() + "：" + bucket.getDocCount());
}
client.close();
~~~



---

#### 8.Elasticsearch 集群

Elasticsearch 集群概念：

1. 分片（Shard）：一个索引可以存储超出单个节点硬件限制的大量数据。而任一节点都可能没有这样大的磁盘空间，为了解决这个问题，Elasticsearch 提供了将索引划分成多份的能力，每一份就称之为分片。

2. 副本（Replicas）：在一个网络/云的环境里，有一个故障转移机制是非常有用并且是强烈推荐的。Elasticsearch 允许创建分片的一份或多份拷贝，这些拷贝叫做副本（一旦创建了拷贝，每个索引就有了主分片和复制分片）。

3. 集群（Cluster）：Elasticsearch 集群是由一个或者多个拥有相同 cluster.name 配置的节点组成，它们共同承担数据和负载的压力。当有节点加入集群中或者从集群中移除节点时，集群将会重新平均分布所有的数据。

   > :ear_of_rice: Elasticsearch 集群健康查看：GET /_cluster/health
   >
   > ~~~json
   > {
   >    "cluster_name":          "elasticsearch",
   >    "status":                "green", 
   >    "timed_out":             false,
   >    "number_of_nodes":       1,
   >    "number_of_data_nodes":  1,
   >    "active_primary_shards": 0,
   >    "active_shards":         0,
   >    "relocating_shards":     0,
   >    "initializing_shards":   0,
   >    "unassigned_shards":     0
   > }
   > ~~~
   >
   > **status** 字段指示着当前集群在总体上是否工作正常。它的三种颜色含义如下：
   >
   > - **`green`**：所有的主分片和副本分片都正常运行。
   > - **`yellow`**：所有的主分片都正常运行，但不是所有的副本分片都正常运行。
   > - **`red`**：有主分片没能正常运行。

4. 节点（Node）：在 Elasticsearch 集群中，每一个单独的 Elasticsearch 服务称为一个节点。

   默认情况下，Elasticsearch 集群节点都是混合节点，即`node.master: true`和`node.data: true`，当集群规模达到一定程度以后，就需要对集群节点进行角色划分，通常我们将Elasticsearch 节点分为主节点、数据节点和客户端节点：

   1. 主节点：`node.master: true`和`node.data: false`，维护元数据，管理集群节点状态，不负责数据写入和查询。
   3. 数据节点：`node.master: false`和`node.data: true`，负责数据的写入与查询。
   4. 客户端节点：`node.master: false`和`node.data: false`，负责任务分发和结果汇聚（类似于负载均衡），分担数据节点压力。



> :bowing_man: 默认情况下创建 Elasticsearch 索引时，Elasticsearch 只会分配 1 个分片和 0 个拷贝，我们也可以在创建索引时添加 RequestBody 内容指定分片和副本数量：
>
> ~~~json
> {
>  "settings": {
>      "number_of_shards": 3,   // 3 个分片
>      "number_of_replicas": 1  // 1 个拷贝
>  }
> }
> ~~~
>
> Elasticsearch 禁止同一个分片的主分片和副本分片在同一个节点上，所以如果是一个节点的集群是不能有副本的。
>
> 分片位置查看请使用：
>
> ~~~http
> http://192.168.253.136:9200/_cat/shards?v
> ~~~



Elasticsearch 集群分配：

1. 单节点集群：当 Elasticsearch 服务只有一个节点时，这一个节点也称为一个集群（单节点集群），在此时创建一个 3 个分片 1 个拷贝的索引时，其分片的分布情况如下：

   ![](./Image/elas_0202.png)

   此时 3 个分片都为主分片（副本分片不会被分配），集群的健康状态为`yellow`。

2. 双节点集群（应对故障）：当集群中只有一个节点在运行时，意味着数据没有冗余，不能有效的解决单点故障问题，我们可以再启动一个节点来防止数据丢失。

   如果在同一个机器上启动第二个 Elasticsearch 节点，只要配置了相同的`cluster.name`，节点就可以自动加入集群，但如果使用不同的机器组成集群，则需要两个节点修改相关配置：

   - 主节点配置：

     ~~~yaml
     cluster.name: my-application  # 集群名称
     node.name: node-1             # 节点名称
     path.data: /var/lib/elasticsearch
     path.logs: /var/log/elasticsearch
     network.host: 192.168.253.136 # 暴露 IP（本机 IP）
     cluster.initial_master_nodes: ["node-1"]  # 初始化 master 节点
     discovery.zen.ping.unicast.hosts: ["192.168.253.136:9300", "192.168.253.137:9300", "192.168.253.135:9300"] # 集群广播地址
     ~~~

     > :jack_o_lantern: Elasticsearch 默认使用 9300 端口作为集群节点间的通讯端口。

   - 副节点配置：

     ~~~yaml
     cluster.name: my-application  # 集群名称
     node.name: node-2             # 节点名称
     path.data: /var/lib/elasticsearch
     path.logs: /var/log/elasticsearch
     network.host: 192.168.253.137 # 暴露 IP（本机 IP）
     cluster.initial_master_nodes: ["node-1"]  # 初始化 master 节点
     discovery.zen.ping.unicast.hosts: ["192.168.253.136:9300", "192.168.253.137:9300"] # 集群广播地址
     ~~~

   修改配置后，开启防火墙的 9200、9300 端口，启动 Elasticsearch 服务。

   第 2 个节点加入集群后，Elasticsearch 将会对分片重新分配，此时 3 个主分片和 3 个复制分片均已被分配，其分布情况如下：

   ![](./Image/elas_0203.png)

   主分片和复制分片位于不同的节点当中，集群状态为`green`。当集群损失任意一个节点时，数据不会丢失。

3. 三节点集群（水平扩容）：当启动了第三个节点后，Elasticsearch 将会为了分散负载而对分片进行重新分配。

   此时的分片分布如下：

   ![](./Image/elas_0204.png)

   此时丢失一个节点不会丢失数据，丢失 2 个节点时也只会丢失 1/3 的数据，我们也可以将`number_of_replicas`调大到 2：

   ~~~json
   PUT /xxx/_settings
   {
      "number_of_replicas" : 2
   }
   ~~~

   ![](D:\GitRepository\HexBook\notes\中间件\分布式服务中间件\Image\elas_0205.png)

   此时就算丢失了 2 个节点，也不会影响集群数据的完整性。

> :dart: 当我们扩容节点时，Elasticsearch 会尽量将分片平均到每一个节点上，这意味着每个节点的硬件资源（CPU, RAM, I/O）将被更少的分片所共享，所以每个分片的性能将会得到提升。
>
> :deciduous_tree: 当我们增加分片的副本数量时，由于读操作可以同时被主分片或副本分片所处理，所以增加分片的副本数量也将拥有更高的吞吐量。



---

#### 9.数据读写原理





作为一个全文检索工具，为数据建立查询索引是必不可少的步骤，索引主要分为 2 种：

1. 正排索引：在向数据库中插入数据时，每一条数据都有一个 ID，以此 ID 作为索引就是正排索引，也是传统的 DBMS 数据库中的索引。
2. 倒排索引：当我们存储以文本形式存在的存储对象时，很多时候我们需要以关键字来进行搜索，这时候我们提取文档中的关键字作为索引，而以文档的 ID 作为值，这样的索引就称为倒排索引。

> :yen: Elasticsearch 中就使用了倒排索引的原理进行全文检索。











3.可视化组件

开源分析和可视化平台 Kibana

安装 Elasticsearch 可视化组件 Kibana：

