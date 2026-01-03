// scripts/auto_button.js

// 注册一个过滤器，在Hexo渲染完文章后执行
hexo.extend.filter.register('before_post_render', function(data){
  
  // 定义按钮的 HTML 代码
  const homeBtn = `
    <div style="margin: 20px 0; text-align: left;">
      <a href="/" style="
          display: inline-block;
          padding: 8px 16px;
          background-color: #000;
          color: #00ff00;
          border: 1px solid #00ff00;
          font-family: 'Consolas', monospace;
          text-decoration: none;
          border-radius: 4px;
          font-weight: bold;
          box-shadow: 0 0 8px rgba(0, 255, 0, 0.4);
          transition: all 0.3s ease;"
         onmouseover="this.style.backgroundColor='#00ff00'; this.style.color='#000';" 
         onmouseout="this.style.backgroundColor='#000'; this.style.color='#00ff00';">
        &lt; cd /home &gt;
      </a>
    </div>
  `;

  // 把按钮插到文章内容的“最前面”
  // data.content 就是 Markdown 转成的 HTML
  data.content = homeBtn + data.content;

  return data;
});