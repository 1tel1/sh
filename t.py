import asyncio
from nats.aio.client 
import Client as NATS

# 定义NATS服务器地址
nats_url = "nats://111.230.6.70:4222"

# 定义XSwitch节点主题
xswitch_node = "cn.xswitch.node.test"

# 定义请求ID
request_id = 0

# 定义请求字典，用于记录每个请求的状态
requests = {}

# 定义异步函数，用于处理收到的消息
async def on_message(msg):
global request_id, 
requests
# 将消息转换为字典格式
data = msg.data.decode()
data = eval(data)
# 判断消息类型
if data["method"] == "Event.Channel": # 如果是Channel事件
event = data["params"]["event"] # 获取事件名称
uuid = data["params"]["uuid"] # 获取Channel UUID
caller = data["params"]["caller"] # 获取主叫号码
callee = data["params"]["callee"] # 获取被叫号码
if event == "START": # 如果是来电事件
if caller.startswith("8613"): # 如果主叫号码以8613开头
request_id += 1 # 生成一个新的请求ID
requests[request_id] = uuid # 记录请求ID和Channel UUID的对应关系
# 发送Transfer命令，将1000转接到1001，并指定回复主题和请求ID
await nc.publish(xswitch_node, f'{{"jsonrpc":"2.0","id":"{request_id}","method":"XNode.Transfer","params":{{"uuid":"{uuid}","dest":"1001","reply":"{inbox}"}}}}'.encode())
elif event == "DESTROY": # 如果是挂机事件
for key, value in requests.items(): # 遍历请求字典
if value == uuid: # 如果找到对应的Channel UUID
del requests[key] # 删除该请求记录
break # 结束循环
elif data["result"]: # 如果是结果消息
result = data["result"] # 获取结果内容
code = result["code"] # 获取结果状态码
message = result["message"] # 获取结果信息
rid = result["id"] # 获取结果对应的请求ID
if rid in requests: # 如果请求ID在请求字典中存在
uuid = requests[rid] # 获取对应的Channel UUID
if code == 200: # 如果状态码为200，表示成功
print(f"Transfer {uuid} successfully.") # 打印成功信息
else: # 否则表示失败
print(f"Transfer {uuid} failed: {message}") # 打印失败信息

# 创建一个异步循环对象
loop = asyncio.get_event_loop()

# 创建一个NATS客户端对象
nc = NATS()

# 连接到NATS服务器，并订阅XSwitch节点主题和一个随机生成的回复主题（inbox）
async def run(loop):
await nc.connect(nats_url, loop=loop)
await nc.subscribe(xswitch_node, cb=on_message)
inbox = nc.new_inbox()
await nc.subscribe(inbox, cb=on_message)

# 运行异步循环，直到被中断（Ctrl+C）
if __name__ == '__main__':
try:
loop.run_until_complete(run(loop))
loop.run_forever()
except KeyboardInterrupt:
pass
