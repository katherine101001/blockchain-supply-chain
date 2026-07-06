# import os
# from dotenv import load_dotenv
# from sqlalchemy import create_engine
# from sqlalchemy.pool import NullPool  # <--- 新增这个导入

# # 1. 加载环境变量
# # Render 上没有 .env 文件，load_dotenv() 会自动跳过并读取系统设置
# load_dotenv()

# # 2. 读取变量
# SEPOLIA_RPC_URL = os.getenv("SEPOLIA_RPC_URL")
# CONTRACT_ADDRESS = os.getenv("CONTRACT_ADDRESS")
# PRIVATE_KEY = os.getenv("PRIVATE_KEY")

# # 数据库链接 (确保 Render 后台的 Key 是 DB_URL)
# DB_URL = os.getenv("DB_URL") 

# # 3. 创建 Engine (针对 Supabase 的关键改动)
# # 如果你使用的是 Supabase 的连接池 (端口 6543)，
# # 必须添加 poolclass=NullPool，否则连接会经常断开。
# if DB_URL and "6543" in DB_URL:
#     engine = create_engine(DB_URL, poolclass=NullPool)
# else:
#     engine = create_engine(DB_URL)

# # 调试日志
# if DB_URL:
#     print(f"✅ DB Config loaded for host: {DB_URL.split('@')[-1].split('/')[0]}")

import os
from dotenv import load_dotenv
from sqlalchemy import create_engine
from sqlalchemy.pool import NullPool  # <--- 新增这个导入

# 1. 加载环境变量
# Render 上没有 .env 文件，load_dotenv() 会自动跳过并读取系统设置
load_dotenv()

# 2. 读取变量
SEPOLIA_RPC_URL = os.getenv("SEPOLIA_RPC_URL")
CONTRACT_ADDRESS = os.getenv("CONTRACT_ADDRESS")
PRIVATE_KEY = os.getenv("PRIVATE_KEY")

# 数据库链接 (确保 Render 后台的 Key 是 DB_URL)
DB_URL = os.getenv("DB_URL") 

# --- CRITICAL SAFETY CHECKS ADDED HERE ---

# 检查 1: 确保 DB_URL 不是空的
# ... (imports and load_dotenv)
load_dotenv(override=True)
DB_URL = os.getenv("DB_URL")

# ADD THIS LINE FOR DEBUGGING:
print(f"DEBUG: The value of DB_URL is: '{DB_URL}'")

if not DB_URL:
    raise ValueError("FATAL: DB_URL is None. Python cannot see your .env variables!")

# ... (the rest of your engine logic)
# 检查 2: 修复 Render 默认的 postgres:// 前缀问题，SQLAlchemy 需要 postgresql://
if DB_URL.startswith("postgres://"):
    DB_URL = DB_URL.replace("postgres://", "postgresql://", 1)

# -----------------------------------------

# 3. 创建 Engine (针对 Supabase 的关键改动)
# 如果你使用的是 Supabase 的连接池 (端口 6543)，
# 必须添加 poolclass=NullPool，否则连接会经常断开。
if "6543" in DB_URL:
    engine = create_engine(DB_URL, poolclass=NullPool)
else:
    engine = create_engine(DB_URL)

# 调试日志
print(f"✅ DB Config loaded for host: {DB_URL.split('@')[-1].split('/')[0]}")