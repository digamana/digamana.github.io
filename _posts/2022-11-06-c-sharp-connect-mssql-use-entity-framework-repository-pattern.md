---
layout: post
title: C# Connect MSSQL Use Entity Framework Repository Pattern
date: 2022-11-06 14:05 +0800
categories: [Visual studio And MSSQL,C# CRUD MSSQL Use Entity Framework Repository Pattern]
---
## 快速建立Repository Pattern的影片教學
詳見以下影片與GIT資源直接簡單建立檔案
<iframe width="560" height="315" src="https://www.youtube.com/embed/RFGdW_CmNyQ" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>  
[Github Source Code](https://github.com/digamana/CreatEntityFrameworkRepositoryPatternRepo  )


1.完成新增ADO.NET的操作 如「[Entity Framework Code First if DataBase Exist-1]({{ site.baseurl }}{% link _posts/2022-10-29-entity-framework-code-first-if-database-exist.md %})」 

2.Creat New Class Name： IRepository.cs
<script  type='text/javascript' src=''>

    using System;
    using System.Collections.Generic;
    using System.Linq.Expressions;
    namespace Entity_Framework_Repository_Pattern
    {
        public interface IRepository<TEntity> where TEntity : class
        {
            TEntity Get(string id);
            IEnumerable<TEntity> GetAll();
            IEnumerable<TEntity> Find(Expression<Func<TEntity, bool>> predicate);
            TEntity SingleOrDefault(Expression<Func<TEntity, bool>> predicate);
            void Add(TEntity entity);
            void AddRange(IEnumerable<TEntity> entities);
            void Remove(TEntity entity);
            void RemoveRange(IEnumerable<TEntity> entities);
        }
    }


3.Creat New Class Name： IMemberRepository.cs
<script  type='text/javascript' src=''>

    namespace Entity_Framework_Repository_Pattern
    {
        public interface IMemberRepository : IRepository<Member>
        {

        }
    }



4.Creat New Class Name： Repository.cs
<script  type='text/javascript' src=''>

    using System;
    using System.Collections.Generic;
    using System.Data.Entity;
    using System.Linq;
    using System.Linq.Expressions;

    namespace Entity_Framework_Repository_Pattern
    {
        public class Repository<TEntity> : IRepository<TEntity> where TEntity : class
        {
            protected readonly DbContext Context;

            public Repository(DbContext context)
            {
                Context = context;
            }

            public TEntity Get(string id)
            {
                return Context.Set<TEntity>().Find(id);
            }

            public IEnumerable<TEntity> GetAll()
            {
                return Context.Set<TEntity>().ToList();
            }

            public IEnumerable<TEntity> Find(Expression<Func<TEntity, bool>> predicate)
            {
                return Context.Set<TEntity>().Where(predicate);
            }

            public TEntity SingleOrDefault(Expression<Func<TEntity, bool>> predicate)
            {
                return Context.Set<TEntity>().SingleOrDefault(predicate);
            }

            public void Add(TEntity entity)
            {
                Context.Set<TEntity>().Add(entity);
            }

            public void AddRange(IEnumerable<TEntity> entities)
            {
                Context.Set<TEntity>().AddRange(entities);
            }

            public void Remove(TEntity entity)
            {
                Context.Set<TEntity>().Remove(entity);
            }

            public void RemoveRange(IEnumerable<TEntity> entities)
            {
                Context.Set<TEntity>().RemoveRange(entities);
            }
        }
    }



5.Creat New Class Name : MemberRepository.cs
<script  type='text/javascript' src=''>

    namespace Entity_Framework_Repository_Pattern
    {
        public class MemberRepository : Repository<Member>, IMemberRepository
        {
            public MemberRepository(Model1 context) : base(context)
            {
            }
            public Model1 Model1
            {
                get { return Context as Model1; }
            }
        }
    }


6.Creat New Class Name : IUnitOfWork.cs
<script  type='text/javascript' src=''>

    using System;

    namespace Entity_Framework_Repository_Pattern
    {
        public interface IUnitOfWork : IDisposable
        {
            IMemberRepository Member { get; }
            int Complete();
        }
    }


7.Creat New Class Name : UnitOfWork.cs
<script  type='text/javascript' src=''>

    using System.Collections.Generic;
    using System.Linq;

    namespace Entity_Framework_Repository_Pattern
    {
        public class UnitOfWork : IUnitOfWork
        {
            private readonly Model1 _context;
            public IMemberRepository Member { get; private set; }

            public UnitOfWork(Model1 context)
            {
                _context = context;
                Member = new MemberRepository(_context);
            }
            public int Complete()
            {
                return _context.SaveChanges();
            }
            public void Dispose()
            {
                _context.Dispose();
            }
        }
    }


8.檔案結構化(可省略)
![Desktop View](/assets/img/2022-11-06-c-sharp-connect-mssql-use-entity-framework-repository-pattern/2.png){: width="600" height="500" }


9.Read MSSQL  
![Desktop View](/assets/img/2022-11-06-c-sharp-connect-mssql-use-entity-framework-repository-pattern/3.png){: width="600" height="500" }
<script  type='text/javascript' src=''>

    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Text;
    using System.Threading.Tasks;

    namespace Entity_Framework_Repository_Pattern
    {
        internal class Program
        {
            static void Main(string[] args)
            {
                using (var unitOfWork = new  UnitOfWork(new Model1()))
                {
                    var result = unitOfWork.Member.GetAll();
                    foreach (var item in result)
                    {
                        Console.WriteLine($"{item.UserID} {item.UserName} {item.UserEmail}");
                    }
                }
                Console.ReadKey();
            }
        }
    }



## 可以搭配的技術
- [Code First]({{ site.baseurl }}{% link _posts/2022-10-29-entity-framework-code-first-if-database-exist.md %})
- [使用Autofac實現DI注入容器]({{ site.baseurl }}{% link _posts/2022-11-09-C-Sharp Container Use Autofac.md %})
