local setup, comment = pcall(require, "Comment")
if not setup then
    print("No comment installed")
    return
end
comment.setup()
